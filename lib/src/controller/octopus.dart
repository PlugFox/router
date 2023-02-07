import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../parser/information_parser.dart';
import '../provider/information_provider.dart';
import '../route/octopus_route.dart';
import '../state/octopus_state.dart';
import 'octopus_delegate.dart';

/// {@template octopus}
/// The main class of the package.
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
      final error = StateError('Routes should contain at least one route');
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
    required RouteInformationProvider routeInformationProvider,
    required RouteInformationParser<OctopusState> routeInformationParser,
    required RouterDelegate<OctopusState> routerDelegate,
    required BackButtonDispatcher backButtonDispatcher,
  }) : config = RouterConfig<OctopusState>(
          routeInformationProvider: routeInformationProvider,
          routeInformationParser: routeInformationParser,
          routerDelegate: routerDelegate,
          backButtonDispatcher: backButtonDispatcher,
        );

  @override
  final RouterConfig<OctopusState> config;
}
