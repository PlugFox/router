import 'package:flutter/widgets.dart';

/// Base class for all routes.
@immutable
abstract class OctopusRoute {
  const OctopusRoute._(this.name);

  /// Name of the route.
  final String name;

  /// Whether this route is home.
  bool get isHome => false;

  // TODO(plugfox): visitor pattern
}

/// {@template octopus_route_page}
/// Route for [Page].
/// {@endtemplate}
abstract class OctopusRoute$Page extends OctopusRoute {
  /// {@macro octopus_route_page}
  const OctopusRoute$Page(String name) : super._(name);

  /// Build [Page] for this route.
  Page<void> call(BuildContext context, Map<String, String> arguments);
}

/* abstract class OctopusRoute$Tabs extends OctopusRoute {
  const OctopusRoute$Tabs(String name) : super._(name);

  Page<void> call(BuildContext context, Map<String, String> arguments);
} */

/* abstract class OctopusRoute$Navigator extends OctopusRoute {
  const OctopusRoute$Navigator(String name) : super._(name);

  /* Page<void> call(BuildContext context, Map<String, String> arguments); */
} */
