import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:octopus/src/util/eval.dart';

import '../error/error.dart';
import '../state/octopus_state.dart';
import '../widget/inherited_octopus.dart';

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

  /// Current configuration.
  OctopusState? _currentConfiguration;

  @override
  OctopusState get currentConfiguration {
    final state = _currentConfiguration;
    if (state == null) throw UnsupportedError('Initial configuration not set');
    return state;
  }

  /// WidgetApp's navigator.
  NavigatorState? get navigator => _modalObserver.navigator;
  final NavigatorObserver _modalObserver = RouteObserver<ModalRoute<Object?>>();

  @override
  Future<void> setNewRoutePath(covariant OctopusState configuration) =>
      $eval((pause) async {
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

        pause();

        // TODO(plugfox): merge newConfiguration with currentConfiguration
        // exclude dublicates and normolize

        // If unchanged, do nothing
        //if (_currentConfiguration == configuration) {
        //  return SynchronousFuture<void>(null);
        //}

        _currentConfiguration = newConfiguration;
        pause();
        notifyListeners();

        // Use [SynchronousFuture] so that the initial url is processed
        // synchronously and remove unwanted initial animations on deep-linking
        return SynchronousFuture<void>(null);
      });

  @override
  Future<bool> popRoute() {
    final nav = navigator;
    assert(nav != null, 'Navigator is not attached to the OctopusDelegate');
    if (nav == null) return SynchronousFuture<bool>(false);
    return nav.maybePop();
  }

  @override
  Widget build(BuildContext context) => Inheritedoctopus(
        child: Navigator(
          restorationScopeId: _restorationScopeId,
          reportsRouteUpdateToEngine: true,
          observers: <NavigatorObserver>[
            _modalObserver,
            ...?_observers,
          ],
          transitionDelegate: _transitionDelegate,
          pages: const <Page<Object?>>[
            // TODO(plugfox): Pages from the current [OctopusState]
          ],
          onPopPage: _onPopPage,
          onUnknownRoute: _onUnknownRoute,
        ),
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
}
