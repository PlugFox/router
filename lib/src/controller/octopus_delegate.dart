import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:octopus/src/widget/octopus_navigator.dart';

import '../error/error.dart';
import '../state/octopus_state.dart';
import 'octopus.dart';

/// Octopus delegate.
class OctopusDelegate extends RouterDelegate<OctopusState>
    with ChangeNotifier, _OctopusStateObserver {
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

  /// Has initial configuration and initialisated.
  @protected
  bool get hasConfiguration => _value != null;

  /// Current configuration.
  @override
  OctopusState get currentConfiguration => _handleErrors(() {
        return value;
      });

  /// WidgetApp's navigator.
  NavigatorState? get navigator => _modalObserver.navigator;
  final NavigatorObserver _modalObserver = RouteObserver<ModalRoute<Object?>>();

  @override
  Future<void> setNewRoutePath(covariant OctopusState configuration) {
    _handleErrors(() {
      OctopusState? newConfiguration = configuration;
      if (configuration is InvalidOctopusState) {
        newConfiguration = _value;
        _onError?.call(configuration.error, configuration.stackTrace);
      } else {
        final error = configuration.validate();
        if (error != null) {
          newConfiguration = _value;
          _onError?.call(error, StackTrace.current);
        }
      }

      // TODO(plugfox): merge newConfiguration with currentConfiguration
      // exclude dublicates and normolize

      // If unchanged, do nothing
      //if (_currentConfiguration == configuration) {
      //  return SynchronousFuture<void>(null);
      //}

      changeState(newConfiguration);
      notifyListeners();
    }, (_, __) {});

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
  Future<bool> popRoute() => _handleErrors(() {
        final nav = navigator;
        assert(nav != null, 'Navigator is not attached to the OctopusDelegate');
        if (nav == null) return SynchronousFuture<bool>(false);
        return nav.maybePop();
      });

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

  bool _onPopPage(Route<Object?> route, Object? result) => _handleErrors(
        () {
          if (!route.didPop(result)) return false;
          final popped = value.maybePop();
          if (popped == null) return false;
          setNewRoutePath(popped);
          return true;
        },
        (_, __) => false,
      );

  Route<Object?>? _onUnknownRoute(RouteSettings settings) => _handleErrors(
        () {
          final route = _notFound?.call(settings);
          if (route != null) return route;
          _onError?.call(
            OctopusUnknownRouteException(settings),
            StackTrace.current,
          );
          return null;
        },
        (_, __) => null,
      );

  List<Page<Object?>> _buildPages(BuildContext context) => _handleErrors(() {
        final state = value;
        Iterable<Page<Object?>> pageGenerator() sync* {
          if (state is InvalidOctopusState) return;
          for (final node in state) {
            yield node.route.buildPage(context, node.arguments);
          }
        }

        final pages = pageGenerator().toList();
        if (pages.isNotEmpty) return pages;
        throw FlutterError('The Navigator.pages must not be empty to use the '
            'Navigator.pages API');
      }, (_, stackTrace) {
        const errorMessage = 'The Navigator.pages must not be empty to use the '
            'Navigator.pages API';
        final error = FlutterError(errorMessage);
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
              'error': Error.safeToString(error),
              'stack': stackTrace.toString(),
            },
          )
        ];
      });

  T _handleErrors<T>(
    T Function() callback, [
    T Function(Object error, StackTrace stackTrace)? fallback,
  ]) {
    try {
      return callback();
    } on Object catch (e, s) {
      _onError?.call(e, s);
      if (fallback == null) rethrow;
      return fallback(e, s);
    }
  }
}

mixin _OctopusStateObserver
    on RouterDelegate<OctopusState>, ChangeNotifier
    implements ValueListenable<OctopusState> {
  @protected
  @nonVirtual
  OctopusState? _value;

  @override
  OctopusState get value =>
      _value ?? (throw UnsupportedError('Initial configuration not set'));

  @protected
  @nonVirtual
  void changeState(OctopusState? state) {
    if (state == null) return;
    _value = state;
    notifyListeners();
  }
}
