import 'package:flutter/widgets.dart' show RouteSettings;

/// Error handling for Octopus router.
typedef OctopusErrorCallback = void Function(
  OctopusException exception,
  StackTrace stackTrace,
);

/// Octopus router exception.
// ignore: public_member_api_docs
sealed class OctopusException implements Exception {

  /// Exception message.
  abstract final String message;

  @override
  String toString() => 'OctopusException: $message';
}

/// {@template error_route_not_found}
/// Octopus router exception for invalid route.
///
/// Called when [onGenerateRoute] fails to generate a route.
///
/// Unknown routes can arise either from errors in the app or from external
/// requests to push routes, such as from Android intents.
/// {@endtemplate}
class OctopusUnknownRouteException implements OctopusException {
  /// {@macro error_route_not_found}
  OctopusUnknownRouteException(this.routeSettings);

  /// The route settings that could not be found.
  final RouteSettings routeSettings;

  @override
  String get message => 'Unknown route: ${routeSettings.name}';


  @override
  String toString() => message;
}