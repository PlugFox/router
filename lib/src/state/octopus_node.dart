import 'package:meta/meta.dart';

import '../route/octopus_route.dart';

@immutable
abstract class OctopusNode<T extends OctopusRoute> {
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

  abstract final T route;
  abstract final Map<String, String> arguments;
  abstract final List<OctopusNode> children;

  Map<String, Object?> toJson();

  R map<R>({
    required R Function(OctopusNode$Page node) page,
  });

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
