import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../../octopus.dart';

/// Converts between [RouteInformation] and [OctopusState].
/// {@nodoc}
@internal
class OctopusInformationParser implements RouteInformationParser<OctopusState> {
  OctopusInformationParser(
      {required OctopusRoute home, required Set<OctopusRoute> routes})
      : _home = OctopusState.single(_nodeFromRoute(route: home)!),
        _routes = UnmodifiableMapView<String, OctopusRoute>(
          <String, OctopusRoute>{
            for (final route in routes) route.name: route,
          },
        );

  final OctopusState _home;
  final UnmodifiableMapView<String, OctopusRoute> _routes;

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
    final uri = Uri.tryParse(routeInformation.location ?? '/');
    final state = routeInformation.state ?? <String, Object?>{};
    if (uri is! Uri) {
      assert(false, 'Invalid route information location');
      return SynchronousFuture<OctopusState>(_home);
    }
    if (state is! Map<String, Object?>) {
      assert(false, 'Invalid route information state');
      return SynchronousFuture<OctopusState>(_home);
    }
    final location = _nodesFromUri(uri, _routes);
    // TODO: create OctopusState from location and state
    // contain graph tree of OctopusNode and active list of OctopusNode
    // active graph tree is changed by active list
    // Matiunin Mikhail <plugfox@gmail.com>, 07 January 2023
    return SynchronousFuture<OctopusState>(
      OctopusState(current: location.last, nodes: location),
    );
  }

  @override
  RouteInformation restoreRouteInformation(
    OctopusState configuration,
  ) =>
      RouteInformation(
        location: _uriFromNodes(configuration.location).toString(),
        state: configuration.toJson(),
      );

  static Uri _uriFromNodes(
    List<OctopusNode<OctopusRoute>> nodes,
  ) {
    if (nodes.isEmpty) return Uri(path: '/');
    String encodeNode(String name, Map<String, String?> arguments) {
      if (arguments.isEmpty) return name;
      final buffer = StringBuffer(name)..write('@');
      final entries = arguments.entries.toList()
        ..sort((a, b) => a.key.compareTo(b.key));
      for (final entry in entries) {
        buffer
          ..write(entry.key)
          ..write('=')
          ..write(entry.value);
      }
      return buffer.toString();
    }

    return Uri(
        pathSegments: nodes
            .map<String>(
              (e) => e.map<String>(
                page: (node) => encodeNode(
                  node.route.name,
                  node.arguments,
                ),
              ),
            )
            .toList());
  }

  static List<OctopusNode<OctopusRoute>> _nodesFromUri(
    Uri uri,
    Map<String, OctopusRoute> routes,
  ) {
    final segments = uri.pathSegments;
    if (segments.isEmpty) return <OctopusNode<OctopusRoute>>[];
    final nodes = <OctopusNode<OctopusRoute>>[];
    OctopusNode<OctopusRoute>? prev() => nodes.isEmpty ? null : nodes.last;
    for (var i = segments.length - 1; i != 0; --i) {
      final segment = segments[i];
      final index = segment.indexOf('@');
      final name = index == -1 ? segment : segment.substring(0, index);
      final route = routes[name];
      if (route is! OctopusRoute) {
        assert(false, 'Invalid route name');
        continue;
      }
      final arguments = <String, String>{};
      if (index != -1) {
        final entries = segment.substring(index + 1).split('=');
        if (entries.length.isOdd) {
          assert(false, 'Invalid route arguments');
          continue;
        }
        for (var j = 0; j < entries.length; j += 2) {
          arguments[entries[j]] = entries[j + 1];
        }
      }
      final node = _nodeFromRoute(
        route: route,
        arguments: arguments,
        prev: prev(),
      );
      if (node is! OctopusNode<OctopusRoute>) {
        assert(false, 'Invalid route node');
        continue;
      }
      nodes.add(node);
    }
    return nodes.reversed.toList();
  }

  // TODO: add another types of OctopusNode
  // Matiunin Mikhail <plugfox@gmail.com>, 11 January 2023
  static OctopusNode? _nodeFromRoute({
    required OctopusRoute route,
    Map<String, String> arguments = const <String, String>{},
    OctopusNode<OctopusRoute>? prev,
  }) =>
      OctopusNode.page(route: route, arguments: arguments);
}
