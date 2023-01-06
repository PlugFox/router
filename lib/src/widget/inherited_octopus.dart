import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// {@nodoc}
@internal
class Inheritedoctopus extends InheritedWidget {
  /// {@macro inherited_octopus}
  const Inheritedoctopus({
    required super.child,
    super.key,
  });

  @override
  bool updateShouldNotify(Inheritedoctopus oldWidget) => false;
}
