import 'package:flutter/widgets.dart';

@immutable
abstract class OctopusRoute {
  const OctopusRoute._(this.name);
  final String name;
}

abstract class OctopusRoute$Page extends OctopusRoute {
  const OctopusRoute$Page(String name) : super._(name);

  Page<void> call(BuildContext context, Map<String, String> arguments);
}

abstract class OctopusRoute$IndexedStack extends OctopusRoute {
  const OctopusRoute$IndexedStack(String name) : super._(name);

  /* Page<void> call(BuildContext context, Map<String, String> arguments); */
}

abstract class OctopusRoute$Navigator extends OctopusRoute {
  const OctopusRoute$Navigator(String name) : super._(name);

  /* Page<void> call(BuildContext context, Map<String, String> arguments); */
}
