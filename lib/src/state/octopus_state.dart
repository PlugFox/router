import 'dart:collection';

import 'package:meta/meta.dart';

import '../error/error.dart';
import '../route/octopus_route.dart';
import 'octopus_node.dart';

/// {@template octopus_state}
/// Router whole application state
/// {@endtemplate}
@immutable
abstract class OctopusState {
  /// {@nodoc}
  const OctopusState._();

  /// {@macro octopus_state}
  factory OctopusState({
    required Iterable<OctopusNode<OctopusRoute>> children,
  }) =>
      OctopusStateImpl(
        children: children,
      );

  /// {@macro octopus_state}
  factory OctopusState.single(OctopusNode<OctopusRoute> node) => OctopusState(
        children: <OctopusNode<OctopusRoute>>[node],
      );

  /// Children of this state
  abstract final List<OctopusNode<OctopusRoute>> children;

  /// Try to pop the current node and return new, previus state
  OctopusState? maybePop();

  /// Copy this state with new values
  OctopusState copyWith({
    List<OctopusNode<OctopusRoute>>? newChildren,
  });

  /// Convert this state to JSON.
  Map<String, Object?> toJson();

  /// Validate this state.
  OctopusStateValidationException? validate();

  /// Walks the children of this node.
  void visitChildNodes(NodeVisitor visitor);

  /// Returns a one-line detailed description of the object.
  /// e.g.:
  /// Router {current: Tabs, children: 3}
  String toStringShallow();

  /// Returns a string representation of this node and its descendants.
  /// e.g.:
  /// Router
  /// ├── Tabs
  /// │   ├── Shop
  /// │   │   ├── Category {id: 1}
  /// │   │   ├── Category {id: 24}
  /// │   │   ├── Brand {name: Apple}
  /// │   │   └── Product {id: 123, color: green}
  /// │   ├── Basket
  /// │   └── Account
  /// │       ├── Profile
  /// │       └── Settings
  /// ├── Gallery
  /// └── Camera
  String toStringDeep();

  /// A short, textual description of this element.
  /// e.g.:
  /// OctopusState(current: A, children: 3)
  String toStringShort();

  @override
  String toString();
}

/// {@nodoc}
@internal
class OctopusStateImpl extends OctopusState {
  /// {@nodoc}
  OctopusStateImpl({
    required Iterable<OctopusNode<OctopusRoute>> children,
  })  : children = children is UnmodifiableListView<OctopusNode<OctopusRoute>>
            ? children
            : UnmodifiableListView<OctopusNode<OctopusRoute>>(children),
        super._();

  @override
  final List<OctopusNode<OctopusRoute>> children;

  // TODO(plugfox): implement OctopusState.maybePop()
  @override
  OctopusState? maybePop() => children.length == 1
      ? null
      : copyWith(
          newChildren: children.sublist(0, children.length - 1),
        );

  // TODO(plugfox): implement OctopusState.copyWith()
  @override
  OctopusState copyWith({
    List<OctopusNode<OctopusRoute>>? newChildren,
  }) =>
      OctopusStateImpl(
        children: newChildren ?? children,
      );

  @override
  Map<String, Object?> toJson() => <String, Object?>{
        'children':
            children.map<Map<String, Object?>>((e) => e.toJson()).toList(),
      };

  // TODO(plugfox): implement validation
  @override
  OctopusStateValidationException? validate() => null;

  @override
  void visitChildNodes(NodeVisitor visitor) => children.forEach(visitor);

  @override
  String toStringDeep() {
    final buffer = StringBuffer();
    buffer.writeln(' Root');

    void writeNode(OctopusNode<OctopusRoute> node, int depth) => buffer
      ..write('  ' * depth)
      ..write('├─')
      ..writeln(node.toString());

    void visitor(OctopusNode<OctopusRoute> node, int depth) {
      writeNode(node, depth);
      node.visitChildNodes((node) => visitor(node, depth + 1));
    }

    visitChildNodes((node) => visitor(node, 0));
    return buffer.toString();
  }

  @override
  String toStringShallow() => '/${children.map((e) => e.route.key).join('/')}';

  @override
  String toStringShort() => 'OctopusState(children: ${children.length})';

  @override
  String toString() => toStringShallow();
}

/// Invalid state, when something went wrong.
/// Usually it's a result of a bug in the application
/// or [OctopusInformationParser.parseRouteInformation].
@internal
class InvalidOctopusState extends OctopusState {
  /// Invalid state
  const InvalidOctopusState(this.error, this.stackTrace) : super._();

  /// Error
  final OctopusException error;

  /// Stack trace
  final StackTrace stackTrace;

  @override
  List<OctopusNode<OctopusRoute>> get children =>
      const <OctopusNode<OctopusRoute>>[];

  @override
  OctopusState copyWith({
    List<OctopusNode<OctopusRoute>>? newChildren,
  }) =>
      InvalidOctopusState(error, stackTrace);

  @override
  OctopusState? maybePop() => throw UnimplementedError();

  @override
  Map<String, Object?> toJson() => throw UnimplementedError();

  @override
  OctopusStateValidationException? validate() =>
      OctopusStateValidationException(
        '/',
        error.message,
      );

  @override
  void visitChildNodes(NodeVisitor visitor) {}

  @override
  String toStringDeep() => error.toString();

  @override
  String toStringShallow() => error.toString();

  @override
  String toStringShort() => 'InvalidOctopusState()';

  @override
  String toString() => toStringShort();
}
