import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

/// Base class for all routes.
@immutable
abstract class OctopusRoute {
  const OctopusRoute._(this.name);

  /// Name of the route.
  final String name;

  /// Build [Page] for this route.
  @visibleForOverriding
  Page<Object?> buildPage(BuildContext context, Map<String, String> arguments);
}

/// Base class for all routes that have [OctopusRoute] as owner.
@immutable
mixin OctopusRouteOwner {
  /// Route of this owner.
  OctopusRoute get route;
}

/// {@template octopus_route_page}
/// Route for [Page].
/// {@endtemplate}
abstract class OctopusRoute$Page extends OctopusRoute {
  /// {@macro octopus_route_page}
  const OctopusRoute$Page(String name) : super._(name);

  /// Build [Page] for this route.
  //Page<void> buildPage(BuildContext context, Map<String, String> arguments);
}

/* abstract class OctopusRoute$Tabs extends OctopusRoute {
  const OctopusRoute$Tabs(String name) : super._(name);

  Page<void> buildPage(BuildContext context, Map<String, String> arguments);
} */

/* abstract class OctopusRoute$Navigator extends OctopusRoute {
  const OctopusRoute$Navigator(String name) : super._(name);

  /* Page<void> buildPage(BuildContext context, Map<String, String> arguments); */
} */
