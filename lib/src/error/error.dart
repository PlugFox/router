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


/// {@template error_unknown_route}
/// Octopus router exception for invalid route.
///
/// Called when [onGenerateRoute] fails to generate a route.
///
/// Unknown routes can arise either from errors in the app or from external
/// requests to push routes, such as from Android intents.
/// {@endtemplate}
class OctopusUnknownRouteException implements OctopusException {
  /// {@macro error_unknown_route}
  OctopusUnknownRouteException(this.routeSettings);

  /// The route settings that could not be found.
  final RouteSettings routeSettings;

  @override
  String get message => 'Unknown route: ${routeSettings.name}';


  @override
  String toString() => message;
}


/// {@template error_invalid_route_information_location}
/// Invalid route information location
/// {@endtemplate}
class OctopusInvalidRouteInformationLocation implements OctopusException {
  /// {@macro error_invalid_route_information_location}
  OctopusInvalidRouteInformationLocation(this.location);

  /// The invalid route information location.
  final String? location;

  @override
  String get message =>
  'Invalid route information location: '
  '${location ?? 'null'}';

  @override
  String toString() => message;
}


/// {@template error_invalid_route_information_state}
/// Invalid route information state
/// {@endtemplate}
class OctopusInvalidRouteInformationState implements OctopusException {
  /// {@macro error_invalid_route_information_state}
  OctopusInvalidRouteInformationState(this.state);

  /// The invalid route information state.
  final Object? state;

  @override
  String get message => 'Invalid route information state';

  @override
  String toString() => message;
}


/// {@template error_invalid_route_information_state}
/// Invalid route information state
/// {@endtemplate}
class OctopusStateValidationException implements OctopusException {
  /// {@macro error_invalid_route_information_state}
  OctopusStateValidationException(this.path, this.message);

  /// The invalid router state part.
  final String path;

  @override
  final String message;

  @override
  String toString() => message;
}


/// {@template error_unknown_exception}
/// Octopus router unknown exception.
/// {@endtemplate}
class OctopusRouterUnknownException implements OctopusException {
  /// {@macro error_unknown_exception}
  OctopusRouterUnknownException(this.exception);

  /// The unknown exception.
  final Object exception;

  @override
  String get message => exception.toString();
}