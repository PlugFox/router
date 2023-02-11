import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

import '../../octopus.dart';

/// {@nodoc}
@internal
class InheritedOctopus extends InheritedWidget {
  /// {@nodoc}
  const InheritedOctopus({
    required super.child,
    required this.controller,
    required this.state,
    super.key,
  });

  /// {@nodoc}
  final Octopus controller;

  /// {@nodoc}
  final OctopusState state;

  /// {@nodoc}
  static Octopus get $controller => _$controller ?? _notExistOrDisposed();
  static Octopus? _$controller;

  static Never _notExistOrDisposed() => throw ArgumentError(
        'The octopus controller is not exist or disposed.'
        'Try to create the new one or use it after first build.',
      );

  /// The controller from the closest instance of this class
  /// that encloses the given context, if any.
  /// e.g. `InheritedOctopus.maybeOf(context)`.
  /// {@nodoc}
  static Octopus? maybeOf(BuildContext context, {bool listen = true}) => (listen
          ? context.dependOnInheritedWidgetOfExactType<InheritedOctopus>()
          : context
              .getElementForInheritedWidgetOfExactType<InheritedOctopus>()
              ?.widget as InheritedOctopus?)
      ?.controller;

  static Never _notFoundInheritedWidgetOfExactType() => throw ArgumentError(
        'Out of scope, not found inherited widget '
            'a InheritedOctopus of the exact type.',
        'out_of_scope',
      );

  /// The controller from the closest instance of this class
  /// that encloses the given context.
  /// e.g. `InheritedOctopus.of(context)`
  /// {@nodoc}
  static Octopus of(BuildContext context, {bool listen = true}) =>
      maybeOf(context, listen: listen) ?? _notFoundInheritedWidgetOfExactType();

  @override
  InheritedElement createElement() => _InheritedOctopusElement(this);

  @override
  bool updateShouldNotify(covariant InheritedOctopus oldWidget) =>
      !identical(
        oldWidget.controller,
        controller,
      ) ||
      oldWidget.state != state;
}

class _InheritedOctopusElement extends InheritedElement {
  _InheritedOctopusElement(InheritedOctopus widget) : super(widget);

  @override
  InheritedOctopus get widget => super.widget as InheritedOctopus;

  @override
  void mount(covariant _InheritedOctopusElement? parent, Object? newSlot) {
    InheritedOctopus._$controller = widget.controller;
    super.mount(parent, newSlot);
  }

  @override
  void update(covariant InheritedOctopus newWidget) {
    InheritedOctopus._$controller = newWidget.controller;
    super.update(newWidget);
  }

  @override
  void unmount() {
    super.unmount();
    InheritedOctopus._$controller = null;
  }
}
