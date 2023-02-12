import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../octopus.dart';
import '../error/error.dart';
import '../state/octopus_state.dart';
import 'state_codec.dart';

/// Converts between [RouteInformation] and [OctopusState].
/// {@nodoc}
@internal
class OctopusInformationParser implements RouteInformationParser<OctopusState> {
  /// {@nodoc}
  OctopusInformationParser({required List<OctopusRoute> routes})
      : _codec = OctopusStateCodec(routes);

  final OctopusStateCodec _codec;

  @override
  Future<OctopusState> parseRouteInformationWithDependencies(
    RouteInformation routeInformation,
    BuildContext context,
  ) =>
      parseRouteInformation(routeInformation);

  @override
  Future<OctopusState> parseRouteInformation(RouteInformation route) {
    try {
      return SynchronousFuture<OctopusState>(_codec.encode(route));
    } on Object catch (error, stackTrace) {
      return SynchronousFuture<OctopusState>(
        InvalidOctopusState(
          OctopusEncodeException(exception: error, location: route.location),
          stackTrace,
        ),
      );
    }
  }

  @override
  RouteInformation? restoreRouteInformation(OctopusState state) =>
      _codec.decode(state);
}
