import 'package:flutter/widgets.dart';

@immutable
abstract class OctopusRoute {
  const OctopusRoute._(this.name);
  final String name;

  bool get isHome => false;

  // TODO: visitor pattern
  // Matiunin Mikhail <plugfox@gmail.com>, 11 January 2023
}

abstract class OctopusRoute$Page extends OctopusRoute {
  const OctopusRoute$Page(String name) : super._(name);

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
