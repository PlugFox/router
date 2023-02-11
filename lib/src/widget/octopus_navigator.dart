import 'package:flutter/widgets.dart';

import '../controller/octopus.dart';
import '../state/octopus_state.dart';

/// {@nodoc}
class OctopusNavigator extends Navigator {
  /// {@nodoc}
  const OctopusNavigator({
    required this.controller,
    super.pages = const <Page<Object?>>[],
    super.onPopPage,
    super.onUnknownRoute,
    super.transitionDelegate = const DefaultTransitionDelegate<Object?>(),
    super.reportsRouteUpdateToEngine = false,
    super.clipBehavior = Clip.hardEdge,
    super.observers = const <NavigatorObserver>[],
    super.requestFocus = true,
    super.restorationScopeId,
    super.routeTraversalEdgeBehavior = kDefaultRouteTraversalEdgeBehavior,
    super.key,
  });

  /// {@nodoc}
  final Octopus controller;

  /// {@nodoc}
  static Octopus get $controller => _$controller ?? _notExistOrDisposed();
  static Octopus? _$controller;
  static Never _notExistOrDisposed() => throw ArgumentError(
        'The octopus controller is not exist or disposed.'
            'Try to create the new one or use it after first build.',
        'router_not_exist_or_disposed',
      );

  /// The controller from the closest instance of this class
  /// that encloses the given context, if any.
  /// e.g. `InheritedOctopus.maybeOf(context)`.
  /// {@nodoc}
  static Octopus of(BuildContext context, {bool listen = false}) {
    if (listen) Router.of<OctopusState>(context);
    return _$controller ?? _notFoundInheritedWidgetOfExactType();
  }

  static Never _notFoundInheritedWidgetOfExactType() => throw ArgumentError(
        'Out of scope, not Router widget found in the element tree.',
        'router_out_of_scope',
      );

  @override
  StatefulElement createElement() => _OctopusNavigatorElement(this);
}

class _OctopusNavigatorElement extends StatefulElement {
  _OctopusNavigatorElement(OctopusNavigator widget) : super(widget);

  @override
  OctopusNavigator get widget => super.widget as OctopusNavigator;

  @override
  void mount(Element? parent, Object? newSlot) {
    OctopusNavigator._$controller = widget.controller;
    super.mount(parent, newSlot);
  }

  @override
  void update(covariant OctopusNavigator newWidget) {
    OctopusNavigator._$controller = newWidget.controller;
    super.update(newWidget);
  }

  @override
  void unmount() {
    super.unmount();
    OctopusNavigator._$controller = null;
  }
}
