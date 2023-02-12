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
    required OctopusNode<OctopusRoute> current,
    required Iterable<OctopusNode<OctopusRoute>> children,
  }) =>
      OctopusStateImpl(
        current: current,
        children: children,
      );

  /// {@macro octopus_state}
  factory OctopusState.single(OctopusNode<OctopusRoute> node) => OctopusState(
        current: node,
        children: <OctopusNode<OctopusRoute>>[node],
      );

  /// Current active/visible node
  abstract final OctopusNode<OctopusRoute> current;

  /// Children of this state
  abstract final List<OctopusNode<OctopusRoute>> children;

  /// Active routing path of the application
  /// e.g. /shop/category@id=1/category@id=24/brand&name=Apple/product@id=123&color=green
  List<OctopusNode<OctopusRoute>> get location;

  /// Try to pop the current node and return new, previus state
  OctopusState? maybePop();

  /// Copy this state with new values
  OctopusState copyWith({
    OctopusNode<OctopusRoute>? newCurrent,
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
    // TODO(plugfox): Replace with factory and children based on current
    required this.current,
    required Iterable<OctopusNode<OctopusRoute>> children,
  })  : children = children is UnmodifiableListView<OctopusNode<OctopusRoute>>
            ? children
            : UnmodifiableListView<OctopusNode<OctopusRoute>>(children),
        super._();

  @override
  final OctopusNode<OctopusRoute> current;

  @override
  List<OctopusNode<OctopusRoute>> get location => children;

  @override
  final List<OctopusNode<OctopusRoute>> children;

  // TODO(plugfox): implement OctopusState.maybePop()
  @override
  OctopusState? maybePop() => children.length == 1
      ? null
      : copyWith(
          newCurrent: children[children.length - 2],
          newChildren: children.sublist(0, children.length - 1),
        );

  // TODO(plugfox): implement OctopusState.copyWith()
  @override
  OctopusState copyWith({
    OctopusNode<OctopusRoute>? newCurrent,
    List<OctopusNode<OctopusRoute>>? newChildren,
  }) =>
      OctopusStateImpl(
        current: newCurrent ?? current,
        children: newChildren ?? children,
      );

  @override
  Map<String, Object?> toJson() => <String, Object?>{
        'current': current.toJson(),
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
    buffer.writeln('Root');
    var depth = 0;
    void addNode(OctopusNode<OctopusRoute> node, int depth) {
      buffer
        ..write('  ' * depth)
        ..write('├── ')
        ..write(node.route.name);
      if (node.arguments.isNotEmpty) {
        buffer
          ..write('(')
          ..write(node.arguments.entries
              .map<String>((e) => '${e.key}: ${e.value}')
              .join(', '))
          ..write(')');
      }
      buffer.writeln();
    }

    visitChildNodes((node) {
      depth = 0;
      addNode(node, depth);
    });

    return buffer.toString();
  }

  @override
  String toStringShallow() => '/${location.map((e) => e.route.key).join('/')}';

  @override
  String toStringShort() =>
      'OctopusState(current: $current, children: ${children.length})';

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
    OctopusNode<OctopusRoute>? newCurrent,
    List<OctopusNode<OctopusRoute>>? newChildren,
  }) =>
      InvalidOctopusState(error, stackTrace);

  @override
  OctopusNode<OctopusRoute> get current => throw UnimplementedError();

  @override
  List<OctopusNode<OctopusRoute>> get location => throw UnimplementedError();

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
