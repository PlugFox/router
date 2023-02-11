import 'dart:collection';
import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../route/octopus_route.dart';
import '../state/octopus_state.dart';

/// Converts [RouteInformation] to [OctopusState].
class OctopusStateEncoder extends Converter<RouteInformation, OctopusState> {
  /// Converts [RouteInformation] to [OctopusState].
  OctopusStateEncoder(Iterable<OctopusRoute> routes)
      : _routes = UnmodifiableMapView<String, OctopusRoute>(
          <String, OctopusRoute>{
            for (final route in routes) route.key: route,
          },
        );

  /// The routes to use for decoding.
  /// Key : OctopusRoute
  final Map<String, OctopusRoute> _routes;

  @override
  OctopusState convert(RouteInformation input) {
    // TODO: implement convert
    throw UnimplementedError();
  }
}
