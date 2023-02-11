import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:octopus/src/widget/octopus_navigator.dart';

import '../error/error.dart';
import '../state/octopus_state.dart';
import 'octopus.dart';

/// Octopus delegate.
class OctopusDelegate extends RouterDelegate<OctopusState> with ChangeNotifier {
  /// Octopus delegate.
  OctopusDelegate({
    String? restorationScopeId = 'octopus',
    List<NavigatorObserver>? observers,
    TransitionDelegate<Object?>? transitionDelegate,
    RouteFactory? notFound,
    void Function(Object error, StackTrace stackTrace)? onError,
  })  : _restorationScopeId = restorationScopeId,
        _observers = observers,
        _transitionDelegate =
            transitionDelegate ?? const DefaultTransitionDelegate<Object?>(),
        _notFound = notFound,
        _onError = onError;

  /// The restoration scope id for the navigator.
  final String? _restorationScopeId;

  /// Observers for the navigator.
  final List<NavigatorObserver>? _observers;

  /// Transition delegate.
  final TransitionDelegate<Object?> _transitionDelegate;

  /// Not found route.
  final RouteFactory? _notFound;

  /// Error handler.
  final void Function(Object error, StackTrace stackTrace)? _onError;

  /// Current octopus instance.
  late Octopus _controller;

  @internal
  set $controller(Octopus controller) => _controller = controller;

  /// Current configuration.
  OctopusState? _currentConfiguration;

  /// Has initial configuration and initialisated.
  @protected
  bool get hasConfiguration => _currentConfiguration != null;

  @override
  OctopusState get currentConfiguration {
    final state = _currentConfiguration;
    _onError?.call(
        UnsupportedError('Initial configuration not set'), StackTrace.current);
    if (state == null) throw UnsupportedError('Initial configuration not set');
    return state;
  }

  /// WidgetApp's navigator.
  NavigatorState? get navigator => _modalObserver.navigator;
  final NavigatorObserver _modalObserver = RouteObserver<ModalRoute<Object?>>();

  @override
  Future<void> setNewRoutePath(covariant OctopusState configuration) {
    OctopusState? newConfiguration = configuration;
    if (configuration is InvalidOctopusState) {
      newConfiguration = _currentConfiguration;
      _onError?.call(configuration.error, configuration.stackTrace);
    } else {
      final error = configuration.validate();
      if (error != null) {
        newConfiguration = _currentConfiguration;
        _onError?.call(error, StackTrace.current);
      }
    }

    // TODO(plugfox): merge newConfiguration with currentConfiguration
    // exclude dublicates and normolize

    // If unchanged, do nothing
    //if (_currentConfiguration == configuration) {
    //  return SynchronousFuture<void>(null);
    //}

    _currentConfiguration = newConfiguration;
    notifyListeners();

    // Use [SynchronousFuture] so that the initial url is processed
    // synchronously and remove unwanted initial animations on deep-linking
    return SynchronousFuture<void>(null);
  }

  @override
  Future<void> setInitialRoutePath(covariant OctopusState configuration) =>
      setNewRoutePath(configuration);

  @override
  Future<void> setRestoredRoutePath(covariant OctopusState configuration) =>
      setNewRoutePath(configuration);

  @override
  Future<bool> popRoute() {
    final nav = navigator;
    assert(nav != null, 'Navigator is not attached to the OctopusDelegate');
    if (nav == null) return SynchronousFuture<bool>(false);
    return nav.maybePop();
  }

  @override
  Widget build(BuildContext context) => OctopusNavigator(
        controller: _controller,
        restorationScopeId: _restorationScopeId,
        reportsRouteUpdateToEngine: true,
        observers: <NavigatorObserver>[
          _modalObserver,
          ...?_observers,
        ],
        transitionDelegate: _transitionDelegate,
        pages: _buildPages(context),
        onPopPage: _onPopPage,
        onUnknownRoute: _onUnknownRoute,
      );

  bool _onPopPage(Route<Object?> route, Object? result) {
    if (!route.didPop(result)) return false;
    final popped = _currentConfiguration?.maybePop();
    if (popped == null) return false;
    setNewRoutePath(popped);
    return true;
  }

  Route<Object?>? _onUnknownRoute(RouteSettings settings) {
    final route = _notFound?.call(settings);
    if (route != null) return route;
    _onError?.call(
      OctopusUnknownRouteException(settings),
      StackTrace.current,
    );
    return null;
  }

  List<Page<Object?>> _buildPages(BuildContext context) {
    final state = _currentConfiguration;
    Iterable<Page<Object?>> pageGenerator() sync* {
      if (state == null || state is InvalidOctopusState) return;
      for (final node in state) {
        yield node.route.buildPage(context, node.arguments);
      }
    }

    final pages = pageGenerator().toList();
    if (pages.isNotEmpty) return pages;

    const errorMessage = 'The Navigator.pages must not be empty to use the '
        'Navigator.pages API';
    final error = FlutterError(errorMessage);
    _onError?.call(
      error,
      StackTrace.current,
    );
    return <Page<Object?>>[
      MaterialPage(
        child: Scaffold(
          body: SafeArea(
            child: ErrorWidget.withDetails(
              message: errorMessage,
              error: error,
            ),
          ),
        ),
        arguments: <String, Object?>{
          'message': errorMessage,
          'error': error,
        },
      )
    ];
  }
}
