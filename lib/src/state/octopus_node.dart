import 'package:meta/meta.dart';

import '../route/octopus_route.dart';

@immutable
abstract class OctopusNode<T extends OctopusRoute> {
  const factory OctopusNode.page({
    required T route,
    Map<String, String> arguments,
  }) = OctopusNode$Page;

  const factory OctopusNode.indexedStack({
    required T route,
    required OctopusNode current,
    required List<OctopusNode> children,
    Map<String, String> arguments,
  }) = OctopusNode$IndexedStack;

  const factory OctopusNode.navigator({
    required T route,
    Map<String, String> arguments,
  }) = OctopusNode$Page;

  /* factory OctopusNode.switch({
    required String name,
    Map<String, String> arguments,
  }) = OctopusNode$Page;
*/

  /* const factory OctopusNode({
    required String name,
    required Map<String, String> arguments,
    required List<OctopusNode> children,
  }) = OctopusNodeImpl; */

  /* const factory OctopusNode.fromString(
    String location,
  ) = OctopusNodeImpl.fromString; */

  /* const factory OctopusNode.fromJson(
    Map<String, Object?> json,
  ) = OctopusNodeImpl.fromJson; */

  abstract final T route;
  abstract final Map<String, String> arguments;
  abstract final List<OctopusNode> children;

  // Map<String, Object?> toJson();

  @override
  String toString();
}

@immutable
class OctopusNode$Page<T extends OctopusRoute> implements OctopusNode<T> {
  const OctopusNode$Page({
    required this.route,
    this.arguments = const <String, String>{},
  }); /* : assert(name.isNotEmpty, 'Name must not be empty'); */

  @override
  final T route;

  @override
  final Map<String, String> arguments;

  @override
  List<OctopusNode> get children => <OctopusNode>[];
}

@immutable
class OctopusNode$IndexedStack<T extends OctopusRoute>
    implements OctopusNode<T> {
  const OctopusNode$IndexedStack({
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
}

@immutable
class OctopusNode$Navigator<T extends OctopusRoute> implements OctopusNode<T> {
  const OctopusNode$Navigator({
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
}

/*
class OctopusNode$Switch {

}
*/
