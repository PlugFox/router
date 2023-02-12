import 'dart:collection';
import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../route/octopus_route.dart';
import '../state/octopus_node.dart';
import '../state/octopus_state.dart';
import '../util/utils.dart';

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
    final uri = Uri.tryParse(input.location ?? '/');
    // TODO(plugfox): Use state to restore the tree of nodes.
    /* final state = input.state is Map<String, Object?>
        ? input.state! as Map<String, Object?>
        : <String, Object?>{}; */
    assert(uri != null, 'Invalid route information location');
    final nodes = nodesFromUri(uri?.pathSegments);
    assert(nodes.isNotEmpty, 'Empty nodes');
    return OctopusState(
      current: nodes.last,
      children: nodes,
    );
  }

  /// Returns the [OctopusNode]s from the given [Uri].
  @visibleForTesting
  List<OctopusNode<OctopusRoute>> nodesFromUri(List<String>? segments) {
    final nodes = (segments ?? <String>[])
        .map<OctopusNode<OctopusRoute>?>(nodeFromSegment)
        .whereType<OctopusNode<OctopusRoute>>()
        .toList();
    if (nodes.isNotEmpty) return nodes;
    final root = _routes.values
        .whereType<OctopusRoute$Page>()
        .map<OctopusNode<OctopusRoute>>(OctopusNode.page)
        .first;
    return <OctopusNode<OctopusRoute>>[root];
  }

  /// Returns the node from the given segment.
  /// Examples:
  /// shop
  /// category--id(electronic)
  /// mobile-phone--id(5)--degree-of-protection(IP68)
  @visibleForTesting
  OctopusNode<OctopusRoute>? nodeFromSegment(String segment) {
    final index = segment.indexOf('--');
    final name = Utils.name2key(
      index == -1 ? segment : segment.substring(0, index),
    );
    final route = _routes[name];
    if (route == null) return null;
    final arguments = <String, String>{};
    if (index != -1) {
      final entries = segment.substring(index + 2).split('--');
      for (final e in entries) {
        final i1 = e.indexOf('('), i2 = e.indexOf(')');
        if (i1 == -1 || i1 > i2) continue;
        arguments[Utils.name2key(e.substring(0, i1))] =
            Uri.decodeQueryComponent(e.substring(i1 + 1, i2));
      }
    }
    // TODO(plugfox): Support other types of routes through pattern matching.
    return OctopusNode.page(route, arguments: arguments);
  }
}
