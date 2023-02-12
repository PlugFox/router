import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../parser/information_parser.dart';
import '../provider/information_provider.dart';
import '../route/octopus_route.dart';
import '../state/octopus_node.dart';
import '../state/octopus_state.dart';
import 'octopus_delegate.dart';
import 'octopus_singleton.dart';

/// {@template octopus}
/// The main class of the package.
/// Router configuration is provided by the [routes] parameter.
/// {@endtemplate}
@sealed
abstract class Octopus {
  Octopus._({required this.config});

  /// {@macro octopus}
  factory Octopus({
    required List<OctopusRouteOwner> routes,
    String? restorationScopeId,
    List<NavigatorObserver>? observers,
    TransitionDelegate<Object?>? transitionDelegate,
    RouteFactory? notFound,
    void Function(Object error, StackTrace stackTrace)? onError,
  }) = OctopusImpl;

  /// Get last used [Octopus] instance if it exists and is not disposed.
  /// {@macro octopus}
  static Octopus get instance => $octopusSingleton;

  /// Get controller from the closest instance of this class
  /// that encloses the given context.
  ///
  /// [listen] - whether to listen to changes in the [Octopus] state.
  ///
  /// {@macro octopus}
  static Octopus of(BuildContext context, {bool listen = false}) {
    if (listen) Router.of<OctopusState>(context);
    return instance;
  }

  /// A convenient bundle to configure a [Router] widget.
  final RouterConfig<OctopusState> config;

  /// Current state.
  OctopusState get state;

  /// State observer,
  /// which can be used to listen to changes in the [OctopusState].
  ValueListenable<OctopusState> get stateObserver;

  /// Set new state and rebuild the navigation tree if needed.
  void setState(OctopusState Function(OctopusState state) change);

  /// Navigate to the specified location.
  void navigate(String location);
}

/// {@nodoc}
@internal
class OctopusImpl extends Octopus
    with _OctopusDelegateOwner, _OctopusNavigationMixin {
  /// {@nodoc}
  factory OctopusImpl({
    required List<OctopusRouteOwner> routes,
    String? restorationScopeId = 'octopus',
    List<NavigatorObserver>? observers,
    TransitionDelegate<Object?>? transitionDelegate,
    RouteFactory? notFound,
    void Function(Object error, StackTrace stackTrace)? onError,
  }) {
    // TODO(plugfox): validate routes names uniqueness.
    final list = routes.map<OctopusRoute>((e) => e.route).toList();
    // Get first page route without any required arguments.
    final firstPage = list.whereType<OctopusRoute$Page>().firstOrNull;
    if (firstPage == null) {
      final error = StateError('Routes list should contain at least one route');
      onError?.call(error, StackTrace.current);
      throw error;
    }
    final routeInformationProvider = OctopusInformationProvider();
    final routeInformationParser = OctopusInformationParser(
      routes: list,
    );
    final routerDelegate = OctopusDelegate(
      initialState: OctopusState.single(OctopusNode.page(firstPage)),
      restorationScopeId: restorationScopeId,
      observers: observers,
      transitionDelegate: transitionDelegate,
      notFound: notFound,
      onError: onError,
    );
    final backButtonDispatcher = RootBackButtonDispatcher();
    final controller = OctopusImpl._(
      routeInformationProvider: routeInformationProvider,
      routeInformationParser: routeInformationParser,
      routerDelegate: routerDelegate,
      backButtonDispatcher: backButtonDispatcher,
    );
    // Set controller to the state observer and singleton.
    return $octopusSingleton = controller
      ..stateObserver.$controller = controller;
  }

  OctopusImpl._({
    required OctopusDelegate routerDelegate,
    required RouteInformationProvider routeInformationProvider,
    required RouteInformationParser<OctopusState> routeInformationParser,
    required BackButtonDispatcher backButtonDispatcher,
  })  : stateObserver = routerDelegate,
        super._(
          config: RouterConfig<OctopusState>(
            routeInformationProvider: routeInformationProvider,
            routeInformationParser: routeInformationParser,
            routerDelegate: routerDelegate,
            backButtonDispatcher: backButtonDispatcher,
          ),
        );

  @override
  OctopusState get state => stateObserver.currentConfiguration;

  @override
  final OctopusDelegate stateObserver;
}

mixin _OctopusDelegateOwner on Octopus {
  @override
  abstract final OctopusDelegate stateObserver;
}

mixin _OctopusNavigationMixin on _OctopusDelegateOwner, Octopus {
  @override
  void setState(OctopusState Function(OctopusState state) change) =>
      stateObserver.setNewRoutePath(change(state));

  @override
  void navigate(String location) => config.routeInformationParser
      ?.parseRouteInformation(RouteInformation(location: location))
      .then<void>(stateObserver.setNewRoutePath)
      .ignore();

  /// Push to the active navigation stack.
  /// PushTo
  /// Pop
  /// PopFrom
  /// Activate
  /// Replace
}
