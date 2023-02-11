import 'dart:collection';

import 'package:meta/meta.dart';

import '../route/octopus_route.dart';

/// Base class for all nodes.
@sealed
@immutable
abstract class OctopusNode<T extends OctopusRoute> {
  /// Page node.
  const factory OctopusNode.page({
    required T route,
    Map<String, String> arguments,
  }) = OctopusNode$Page;

  /* const factory OctopusNode.tabs({
    required T route,
    required OctopusNode current,
    required List<OctopusNode> children,
    Map<String, String> arguments,
  }) = OctopusNode$Tabs; */

  /* const factory OctopusNode.navigator({
    required T route,
    Map<String, String> arguments,
  }) = OctopusNode$Navigator; */

  /* factory OctopusNode.switch({
    required String name,
    Map<String, String> arguments,
  }) = OctopusNode$Page; */

  /// Route of this node.
  abstract final T route;

  /// Arguments of this node.
  abstract final Map<String, String> arguments;

  /// Children of this node.
  abstract final List<OctopusNode> children;

  /// Convert this node to JSON.
  Map<String, Object?> toJson();

  /// Pattern matching.
  R map<R>({
    required R Function(OctopusNode$Page node) page,
  });

  /// Walks the children of this node.
  void visitChildNodes(NodeVisitor visitor);

  @override
  String toString();
}

/// Page node.
@immutable
class OctopusNode$Page<T extends OctopusRoute> implements OctopusNode<T> {
  /// Page node.
  const OctopusNode$Page({
    required this.route,
    this.arguments = const <String, String>{},
  }); /* : assert(name.isNotEmpty, 'Name must not be empty'); */

  @override
  final T route;

  @override
  final Map<String, String> arguments;

  @override
  List<OctopusNode> get children => UnmodifiableListView(<OctopusNode>[]);

  @override
  map<R>({
    required R Function(OctopusNode$Page<OctopusRoute> node) page,
  }) =>
      page(this);

  @override
  Map<String, Object?> toJson() => <String, Object?>{
        'route': route.name,
        'type': 'page',
        'arguments': arguments,
      };

  /*
  /// Parent of this node.
  OctopusNode? _parent;

  /// Walks the ancestors of this node.
  void visitAncestorNodes(ConditionalNodeVisitor visitor) {
    OctopusNode? ancestor = _parent;
    while (ancestor != null && visitor(ancestor)) {
      ancestor = ancestor._parent;
    }
  }
  */

  @override
  void visitChildNodes(NodeVisitor visitor) => children.forEach(visitor);
}

/* @immutable
class OctopusNode$Tabs<T extends OctopusRoute> implements OctopusNode<T> {
  const OctopusNode$Tabs({
    required this.route,
    required this.current,
    required this.children,
    this.arguments = const <String, String>{},
  }); /* : assert(name.isNotEmpty, 'Name must not be empty'),
        assert(children.contains(current), 'Current child not in children'),
        assert(children.isNotEmpty, 'Children must not be empty'); */

  @override
  final T route;

  @override
  final Map<String, String> arguments;

  final OctopusNode current;

  @override
  final List<OctopusNode> children;

  @override
  map<R>({
    required R Function(OctopusNode$Page<OctopusRoute> node) page,
    required R Function(OctopusNode$Tabs<OctopusRoute> node) tabs,
  }) =>
      tabs(this);
} */

/*
@immutable
class OctopusNode$Navigator<T extends OctopusRoute> implements OctopusNode<T> {
  const OctopusNode$Navigator({
    required this.route,
    required this.children,
    this.arguments = const <String, String>{},
  }); /* : assert(name.isNotEmpty, 'Name must not be empty'),
        assert(children.contains(current), 'Current child not in children'),
        assert(children.isNotEmpty, 'Children must not be empty'); */

  @override
  final T route;

  @override
  final Map<String, String> arguments;

  @override
  final List<OctopusNode> children;

  @override
  map<R>({
    required R Function(OctopusNode$Page<OctopusRoute> node) page,
    required R Function(OctopusNode$Tabs<OctopusRoute> node) tabs,
    required R Function(OctopusNode$Navigator<OctopusRoute> node) navigator,
  }) =>
      navigator(this);
}

class OctopusNode$Switch {

}
*/

/// Signature for the callback to [OctopusNode.visitChildNodes].
///
/// The argument is the child being visited.
///
/// It is safe to call `node.visitChildNodes` reentrantly within
/// this callback.
typedef NodeVisitor = void Function(OctopusNode element);

/*
/// Signature for the callback to [OctopusNode.visitChildNodes].
///
/// The argument is the ancestor being visited.
///
/// Return false to stop the walk.
typedef ConditionalNodeVisitor = bool Function(OctopusNode element);
*/

