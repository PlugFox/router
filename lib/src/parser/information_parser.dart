import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../octopus.dart';

/// Converts between [RouteInformation] and [OctopusState].
/// {@nodoc}
@internal
class OctopusInformationParser implements RouteInformationParser<OctopusState> {
  OctopusInformationParser();

  @override
  Future<OctopusState> parseRouteInformationWithDependencies(
    RouteInformation routeInformation,
    BuildContext context,
  ) =>
      parseRouteInformation(routeInformation);

  @override
  Future<OctopusState> parseRouteInformation(
    RouteInformation routeInformation,
  ) {
    final location = Uri.tryParse(routeInformation.location ?? '/');
    final state = routeInformation.state ?? <String, Object?>{};
    if (location is! Uri) {
      assert(false, 'Invalid route information location');
    }
    if (state is! Map<String, Object?>) {
      assert(false, 'Invalid route information state');
    }
    // TODO: create OctopusState from location and state
    // contain graph tree of OctopusNode and active list of OctopusNode
    // active graph tree is changed by active list
    // Matiunin Mikhail <plugfox@gmail.com>, 07 January 2023
    throw UnimplementedError();
  }
  //    routeInformation.location, routeInformation.state
  //    SynchronousFuture<OctopusState>();

  @override
  RouteInformation restoreRouteInformation(
    OctopusState configuration,
  ) =>
      RouteInformation(
        location: _locationFromConfiguration(configuration),
        state: configuration.toJson(),
      );

  static String _locationFromConfiguration(OctopusState configuration) {
    bool isFirst = true;
    final StringBuffer buffer = StringBuffer();
    void separate() => isFirst ? isFirst = false : buffer.write('/');
    final nodes = configuration.location;
    for (final node in nodes) {
      separate();
      buffer.write(node.route.name);
      if (node.arguments.isEmpty) continue;
      buffer.write('@');
      final entries = node.arguments.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      for (final entry in entries) {
        buffer
          ..write(entry.key)
          ..write('=')
          ..write(entry.value);
      }
    }
    return buffer.toString();
  }
}
