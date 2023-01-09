import 'dart:collection';

import 'package:meta/meta.dart';
import 'package:octopus/src/route/octopus_route.dart';

import 'octopus_node.dart';

/// {@template octopus_state}
/// Router whole application state
/// {@endtemplate}
@immutable
abstract class OctopusState implements Iterable<OctopusNode<OctopusRoute>> {
  /// Current active/visible node
  OctopusNode<OctopusRoute> get current;

  /// Active routing path of the application
  /// e.g. /shop/category@id=1/category@id=24/brand&name=Apple/product@id=123&color=green
  List<OctopusNode<OctopusRoute>> get location;

  /// Returns the element at the given [index] in the list
  ///  or throws an [RangeError]
  OctopusNode<OctopusRoute> operator [](int index);

  OctopusState copyWith({
    OctopusNode<OctopusRoute>? newCurrent,
    List<OctopusNode<OctopusRoute>>? newNodes,
  });

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

@internal
class OctopusStateImpl extends IterableBase<OctopusNode<OctopusRoute>>
    with _OctopusNodeImmutableListMixin
    implements OctopusState {
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
  OctopusState copyWith({
    OctopusNode<OctopusRoute>? newCurrent,
    List<OctopusNode<OctopusRoute>>? newNodes,
  }) =>
      throw UnimplementedError();

  @override
  Map<String, Object?> toJson() => throw UnimplementedError();

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
