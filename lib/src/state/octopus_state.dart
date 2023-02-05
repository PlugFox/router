import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:octopus/src/route/octopus_route.dart';

import 'octopus_node.dart';

/// {@template octopus_state}
/// Router whole application state
/// {@endtemplate}
@immutable
abstract class OctopusState implements Iterable<OctopusNode<OctopusRoute>> {
  /// {@macro octopus_state}
  factory OctopusState({
    required OctopusNode<OctopusRoute> current,
    required Iterable<OctopusNode<OctopusRoute>> nodes,
  }) =>
      OctopusStateImpl(
        current: current,
        nodes: nodes,
      );

  /// {@macro octopus_state}
  factory OctopusState.single(OctopusNode<OctopusRoute> node) => OctopusState(
        current: node,
        nodes: <OctopusNode<OctopusRoute>>[node],
      );

  /// Current active/visible node
  abstract final OctopusNode<OctopusRoute> current;

  /// Active routing path of the application
  /// e.g. /shop/category@id=1/category@id=24/brand&name=Apple/product@id=123&color=green
  List<OctopusNode<OctopusRoute>> get location;

  /// Returns the element at the given [index] in the list
  ///  or throws an [RangeError]
  OctopusNode<OctopusRoute> operator [](int index);

  /// Try to pop the current node and return new, previus state
  OctopusState? maybePop();

  /// Copy this state with new values
  OctopusState copyWith({
    OctopusNode<OctopusRoute>? newCurrent,
    List<OctopusNode<OctopusRoute>>? newNodes,
  });

  /// Convert this state to JSON.
  Map<String, Object?> toJson();

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
  @override
  String toString();
}

/// {@nodoc}
@internal
class OctopusStateImpl extends IterableBase<OctopusNode<OctopusRoute>>
    with _OctopusNodeImmutableListMixin
    implements OctopusState {
  /// {@nodoc}
  OctopusStateImpl({
    required OctopusNode<OctopusRoute> current,
    required Iterable<OctopusNode<OctopusRoute>> nodes,
  })  : _current = current,
        _location = UnmodifiableListView<OctopusNode<OctopusRoute>>([current]),
        _nodes = UnmodifiableListView<OctopusNode<OctopusRoute>>(nodes);

  @override
  OctopusNode<OctopusRoute> get current => _current;
  final OctopusNode<OctopusRoute> _current;

  @override
  List<OctopusNode<OctopusRoute>> get location => _location;
  final List<OctopusNode<OctopusRoute>> _location;
  @override
  final List<OctopusNode<OctopusRoute>> _nodes;

  @override
  OctopusState? maybePop() => throw UnimplementedError();

  @override
  OctopusState copyWith({
    OctopusNode<OctopusRoute>? newCurrent,
    List<OctopusNode<OctopusRoute>>? newNodes,
  }) =>
      throw UnimplementedError();

  @override
  Map<String, Object?> toJson() => <String, Object?>{
        'current': current.toJson(),
        'nodes': map<Map<String, Object?>>((e) => e.toJson()).toList(),
      };

  @override
  String toString() => throw UnimplementedError();
}

mixin _OctopusNodeImmutableListMixin on IterableBase<OctopusNode<OctopusRoute>>
    implements OctopusState {
  abstract final List<OctopusNode<OctopusRoute>> _nodes;

  @override
  int get length => _nodes.length;

  @override
  OctopusNode<OctopusRoute> get last => _nodes.last;

  @override
  Iterator<OctopusNode<OctopusRoute>> get iterator => _nodes.iterator;

  @override
  OctopusNode<OctopusRoute> operator [](int index) => _nodes.elementAt(index);
}
