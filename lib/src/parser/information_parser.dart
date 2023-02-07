import 'dart:async';
import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';
import 'package:octopus/src/state/octopus_state.dart';

import '../../octopus.dart';
import '../error/error.dart';

/// Converts between [RouteInformation] and [OctopusState].
/// {@nodoc}
@internal
class OctopusInformationParser implements RouteInformationParser<OctopusState> {
  /// {@nodoc}
  OctopusInformationParser({required List<OctopusRoute> routes})
      : _routes = UnmodifiableMapView<String, OctopusRoute>(
          <String, OctopusRoute>{
            '/': routes.first,
            for (final route in routes) route.name: route,
          },
        );

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
      return SynchronousFuture(
        InvalidOctopusState(
          OctopusInvalidRouteInformationLocation(routeInformation.location),
          StackTrace.current,
        ),
      );
    }
    if (state is! Map<String, Object?>) {
      assert(false, 'Invalid route information state');
      return SynchronousFuture(
        InvalidOctopusState(
          OctopusInvalidRouteInformationState(routeInformation.state),
          StackTrace.current,
        ),
      );
    }

    List<OctopusNode<OctopusRoute>> location;
    try {
      location = $nodesFromUri(uri, _routes);
      if (location.isEmpty) {
        assert(false, 'Nodes not found');
        return SynchronousFuture(
          InvalidOctopusState(
            OctopusRouterUnknownException(StateError('Nodes not found')),
            StackTrace.current,
          ),
        );
      }
    } on Object catch (error, stackTrace) {
      return SynchronousFuture(
        InvalidOctopusState(
          OctopusRouterUnknownException(error),
          stackTrace,
        ),
      );
    }
    // TODO(plugfox): create OctopusState from location and state
    // contain graph tree of OctopusNode and active list of OctopusNode
    // active graph tree is changed by active list
    return SynchronousFuture(
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

  /// {@nodoc}
  @internal
  @visibleForTesting
  static List<OctopusNode<OctopusRoute>> $nodesFromUri(
    Uri uri,
    Map<String, OctopusRoute> routes,
  ) {
    final segments = uri.pathSegments;
    if (segments.isEmpty) {
      final rootRoute = routes['/'];
      if (rootRoute == null) {
        throw StateError('Where is the root route?');
      }
      final root = _nodeFromRoute(route: routes['/']!, prev: null);
      if (root == null) {
        throw StateError('We can not create root node');
      }
      return <OctopusNode<OctopusRoute>>[root];
    }
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

  // TODO(plugfox): add another types of OctopusNode
  static OctopusNode? _nodeFromRoute({
    required OctopusRoute route,
    Map<String, String> arguments = const <String, String>{},
    OctopusNode<OctopusRoute>? prev,
  }) =>
      OctopusNode.page(route: route, arguments: arguments);
}
