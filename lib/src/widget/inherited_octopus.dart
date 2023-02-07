import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

/// {@nodoc}
@internal
class InheritedOctopus extends InheritedWidget {
  /// {@macro inherited_octopus}
  const InheritedOctopus({
    required super.child,
    super.key,
  });

  @override
  bool updateShouldNotify(InheritedOctopus oldWidget) => false;
}
