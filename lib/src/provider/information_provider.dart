import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// The route information provider that propagates
/// the platform route information changes.
///
/// This provider also reports the new route information from the [Router] widget
/// back to engine using message channel method, the
/// [SystemNavigator.routeInformationUpdated].
///
/// Each time [SystemNavigator.routeInformationUpdated] is called, the
/// [SystemNavigator.selectMultiEntryHistory] method is also called. This
/// overrides the initialization behavior of
/// [Navigator.reportsRouteUpdateToEngine].
/// {@nodoc}
@internal
class OctopusInformationProvider extends RouteInformationProvider
    with WidgetsBindingObserver, ChangeNotifier {
  OctopusInformationProvider({
    String? initialLocation,
    Map<String, Object?>? initialState,
    Listenable? refreshListenable,
  })  : _value = _initialRouteInformation(initialLocation, initialState),
        _refreshListenable = refreshListenable {
    _refreshListenable?.addListener(notifyListeners);
  }

  static RouteInformation _initialRouteInformation(String? initialLocation,
      [Map<String, Object?>? initialState]) {
    String effectiveInitialLocation() {
      final platformDefault =
          WidgetsBinding.instance.platformDispatcher.defaultRouteName;
      if (initialLocation == null) {
        return platformDefault;
      } else if (platformDefault == '/') {
        return initialLocation;
      } else {
        return platformDefault;
      }
    }

    return RouteInformation(
      location: initialLocation ?? effectiveInitialLocation(),
      state: initialState,
    );
  }

  final Listenable? _refreshListenable;

  static WidgetsBinding get _binding => WidgetsBinding.instance;

  @override
  void routerReportsNewRouteInformation(
    RouteInformation routeInformation, {
    RouteInformationReportingType type = RouteInformationReportingType.none,
  }) {
    // Avoid adding a new history entry if the route is the same as before.
    final replace = type == RouteInformationReportingType.neglect ||
        (type == RouteInformationReportingType.none &&
            _valueInEngine.location == routeInformation.location);
    SystemNavigator.selectMultiEntryHistory();
    SystemNavigator.routeInformationUpdated(
      location: routeInformation.location!,
      replace: replace,
    );
    _value = routeInformation;
    _valueInEngine = routeInformation;
  }

  @override
  RouteInformation get value => _value;
  RouteInformation _value;
  set value(RouteInformation other) {
    final shouldNotify =
        _value.location != other.location || _value.state != other.state;
    _value = other;
    if (shouldNotify) notifyListeners();
  }

  RouteInformation _valueInEngine =
      RouteInformation(location: _binding.platformDispatcher.defaultRouteName);

  void _platformReportsNewRouteInformation(RouteInformation routeInformation) {
    if (_value == routeInformation) return;
    _value = routeInformation;
    _valueInEngine = routeInformation;
    notifyListeners();
  }

  @override
  void addListener(VoidCallback listener) {
    if (!hasListeners) _binding.addObserver(this);
    super.addListener(listener);
  }

  @override
  void removeListener(VoidCallback listener) {
    super.removeListener(listener);
    if (!hasListeners) _binding.removeObserver(this);
  }

  @override
  void dispose() {
    if (hasListeners) _binding.removeObserver(this);
    _refreshListenable?.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) {
    assert(
        hasListeners,
        'A OctopusInformationProvider must have '
        'at least one listener before it can be used.');
    _platformReportsNewRouteInformation(
      routeInformation,
    );
    return SynchronousFuture<bool>(true);
  }

  @override
  Future<bool> didPushRoute(String route) {
    assert(
        hasListeners,
        'A OctopusInformationProvider must have '
        'at least one listener before it can be used.');
    final state = _value.state;
    _platformReportsNewRouteInformation(
      RouteInformation(
        location: route,
        state: state,
      ),
    );
    return SynchronousFuture<bool>(true);
  }
}
