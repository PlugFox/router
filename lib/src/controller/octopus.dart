import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:octopus/src/widget/inherited_octopus.dart';

import '../parser/information_parser.dart';
import '../provider/information_provider.dart';
import '../route/octopus_route.dart';
import '../state/octopus_state.dart';
import 'octopus_delegate.dart';

/// {@template octopus}
/// The main class of the package.
/// Router configuration is provided by the [routes] parameter.
/// {@endtemplate}
abstract class Octopus {
  /// {@macro octopus}
  factory Octopus({
    required List<OctopusRouteOwner> routes,
    String? restorationScopeId,
    List<NavigatorObserver>? observers,
    TransitionDelegate<Object?>? transitionDelegate,
    RouteFactory? notFound,
    void Function(Object error, StackTrace stackTrace)? onError,
  }) = OctopusImpl;

  /// A convenient bundle to configure a [Router] widget.
  abstract final RouterConfig<OctopusState> config;

  /// Get last used [Octopus] instance if it exists and is not disposed.
  /// {@macro octopus}
  static Octopus get instance => InheritedOctopus.$controller;

  /// Get controller from the closest instance of this class
  /// that encloses the given context.
  ///
  /// [listen] - whether to listen to changes in the [Octopus] state.
  ///
  /// {@macro octopus}
  static Octopus of(BuildContext context, {bool listen = false}) =>
      InheritedOctopus.of(context, listen: listen);

  /// Current state.
  OctopusState get state;
}

/// {@nodoc}
@sealed
@internal
class OctopusImpl implements Octopus {
  /// {@nodoc}
  factory OctopusImpl({
    required List<OctopusRouteOwner> routes,
    String? restorationScopeId = 'octopus',
    List<NavigatorObserver>? observers,
    TransitionDelegate<Object?>? transitionDelegate,
    RouteFactory? notFound,
    void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    final list = routes.map<OctopusRoute>((e) => e.route).toList();
    if (list.isEmpty) {
      final error = StateError('Routes list should contain at least one route');
      onError?.call(error, StackTrace.current);
      throw error;
    }
    final routeInformationProvider = OctopusInformationProvider();
    final routeInformationParser = OctopusInformationParser(
      routes: list,
    );
    final routerDelegate = OctopusDelegate(
      restorationScopeId: restorationScopeId,
      observers: observers,
      transitionDelegate: transitionDelegate,
      notFound: notFound,
      onError: onError,
    );
    final backButtonDispatcher = RootBackButtonDispatcher();
    return OctopusImpl._(
      routeInformationProvider: routeInformationProvider,
      routeInformationParser: routeInformationParser,
      routerDelegate: routerDelegate,
      backButtonDispatcher: backButtonDispatcher,
    );
  }

  OctopusImpl._({
    required OctopusDelegate routerDelegate,
    required RouteInformationProvider routeInformationProvider,
    required RouteInformationParser<OctopusState> routeInformationParser,
    required BackButtonDispatcher backButtonDispatcher,
  })  : _delegate = routerDelegate,
        config = RouterConfig<OctopusState>(
          routeInformationProvider: routeInformationProvider,
          routeInformationParser: routeInformationParser,
          routerDelegate: routerDelegate,
          backButtonDispatcher: backButtonDispatcher,
        ) {
    routerDelegate.$controller = this;
  }

  @override
  final RouterConfig<OctopusState> config;

  /// {@nodoc}
  final OctopusDelegate _delegate;

  @override
  OctopusState get state => _delegate.currentConfiguration;
}

Never _notFoundInheritedWidgetOfExactType() => throw ArgumentError(
      'Out of scope, not found inherited widget '
          'a InheritedOctopus of the exact type',
      'out_of_scope',
    );
