import 'package:flutter/widgets.dart' show RouteSettings;
import 'package:meta/meta.dart';

import '../state/octopus_state.dart';

/// Error handling for Octopus router.
typedef OctopusErrorCallback = void Function(
  OctopusException exception,
  StackTrace stackTrace,
);

/// Octopus router exception.
@sealed
abstract class OctopusException implements Exception {
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
class OctopusUnknownRouteException extends OctopusException {
  /// {@macro error_unknown_route}
  OctopusUnknownRouteException(this.routeSettings);

  /// The route settings that could not be found.
  final RouteSettings routeSettings;

  @override
  String get message => 'Unknown route: ${routeSettings.name}';

  @override
  String toString() => message;
}

/// {@template error_encode_exception}
/// Route information location encoding exception.
/// {@endtemplate}
class OctopusEncodeException extends OctopusException {
  /// {@macro error_encode_exception}
  OctopusEncodeException({
    required this.exception,
    this.location,
  });

  /// Route information location.
  final String? location;

  /// The exception.
  final Object exception;

  @override
  String get message => 'Location${location != null ? ' "$location"' : ''} '
      'encoding exception: $exception';

  @override
  String toString() => message;
}

/// {@template error_decode_exception}
/// Route information state decoding exception.
/// {@endtemplate}
class OctopusDecodeException extends OctopusException {
  /// {@macro error_decode_exception}
  OctopusDecodeException({
    required this.exception,
    required this.state,
  });

  /// The exception.
  final Object exception;

  /// Invalid router state.
  final OctopusState state;

  @override
  String get message => 'State encoding exception: $exception';

  @override
  String toString() => message;
}

/// {@template error_invalid_route_information_state}
/// Invalid route information state
/// {@endtemplate}
class OctopusStateValidationException extends OctopusException {
  /// {@macro error_invalid_route_information_state}
  OctopusStateValidationException(this.path, this.message);

  /// The invalid router state part.
  final String path;

  @override
  final String message;

  @override
  String toString() => message;
}
