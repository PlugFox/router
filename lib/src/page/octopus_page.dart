import 'package:flutter/widgets.dart';

/// {@template octopus_route}
/// Octopus page abstraction
///
/// This class is used to pass route information to the [OctopusState]
/// It is a copy of [RouteSettings] with the addition of the [name] field
///
/// Can be parsed and extract from [RouteInformation] or
/// construct with [OctopusRoute] factory constructor, e.g.:
/// ```dart
/// @sealed
/// @immutable
/// class ProductRouteFactory {
///   static const String name = 'product';
///   OctopusRoute call({required int id}) => OctopusRoute(
///         name: name,
///         arguments: <String, Object?>{'id': id},
///       );
/// }
/// ```
/// {@endtemplate}
@immutable
abstract class OctopusPage<T> implements Page<T> {
  /* /// {@macro octopus_route}
  const factory OctopusPage({
    required String name,
    required Map<String, Object?> arguments,
  }) = OctopusRouteSettingsImpl; */

  @override
  abstract final String name;

  @override
  abstract final Map<String, Object?> arguments;

  @override
  abstract final LocalKey key;

  @override
  abstract final String restorationId;
}
