import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../route/octopus_route.dart';
import '../state/octopus_node.dart';
import '../state/octopus_state.dart';
import '../util/utils.dart';

/// Converts [OctopusState] to [RouteInformation].
class OctopusStateDecoder extends Converter<OctopusState, RouteInformation> {
  /// Converts [OctopusState] to [RouteInformation].
  const OctopusStateDecoder();

  @override
  RouteInformation convert(covariant OctopusState input) {
    // TODO(plugfox): Use state to restore the tree of nodes.
    return RouteInformation(
      location: input.isEmpty ? null : uriFromNodes(input.toList())?.join('/'),
      // state: <String, Object?>{},
    );
  }

  /// Returns the [Uri] from the given [OctopusNode]s.
  @visibleForTesting
  List<String>? uriFromNodes(List<OctopusNode<OctopusRoute>> nodes) {
    final segments =
        nodes.map<String?>(segmentFromNode).whereType<String>().toList();
    if (segments.isNotEmpty) {
      return <String>[
        '/${segments.first}',
        ...segments.skip(1),
      ];
    }
    return null;
  }

  /// Returns the segment from the given node.
  /// Examples:
  /// shop
  /// category--id(electronic)
  /// mobile-phone--id(5)--degree-of-protection(IP68)
  @visibleForTesting
  String? segmentFromNode(OctopusNode<OctopusRoute> node) {
    final buffer = StringBuffer(node.route.key);
    for (final arg in node.arguments.entries) {
      buffer
        ..write('--')
        ..write(Utils.name2key(arg.key))
        ..write('(')
        ..write(Uri.encodeQueryComponent(arg.value))
        ..write(')');
    }
    // TODO(plugfox): Support other types of routes through pattern matching.
    return buffer.toString();
  }
}
