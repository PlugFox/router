import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../parser/information_parser.dart';
import '../provider/information_provider.dart';
import '../route/octopus_route.dart';
import '../state/octopus_state.dart';
import 'octopus_delegate.dart';

/// {@template octopus}
/// The main class of the package.
/// {@endtemplate}
abstract class Octopus {
  factory Octopus({required List<OctopusRoute> routes}) = OctopusImpl;
  abstract final RouterConfig<OctopusState> config;
}

/// {@nodoc}
@sealed
@internal
class OctopusImpl implements Octopus {
  factory OctopusImpl({required List<OctopusRoute> routes}) {
    final routeInformationProvider = OctopusInformationProvider();
    final routeInformationParser = OctopusInformationParser();
    final routerDelegate = OctopusDelegate();
    final backButtonDispatcher = RootBackButtonDispatcher();
    return OctopusImpl._(
      routeInformationProvider: routeInformationProvider,
      routeInformationParser: routeInformationParser,
      routerDelegate: routerDelegate,
      backButtonDispatcher: backButtonDispatcher,
    );
  }

  OctopusImpl._({
    required RouteInformationProvider routeInformationProvider,
    required RouteInformationParser<OctopusState> routeInformationParser,
    required RouterDelegate<OctopusState> routerDelegate,
    required BackButtonDispatcher backButtonDispatcher,
  }) : config = RouterConfig<OctopusState>(
          routeInformationProvider: routeInformationProvider,
          routeInformationParser: routeInformationParser,
          routerDelegate: routerDelegate,
          backButtonDispatcher: backButtonDispatcher,
        );

  @override
  final RouterConfig<OctopusState> config;
}
