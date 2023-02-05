/* abstract class Widget {
  const Widget();
  Element createElement();
}

abstract class Element {
  factory Element(Widget widget) => throw UnimplementedError();

  abstract Widget widget;

  void mount(Element? parent, Object? newSlot) {}

  Element inflateWidget(Widget newWidget, Object? newSlot) {
    final Element newChild = newWidget.createElement();
    newChild.mount(this, newSlot);
    return newChild;
  }
}

class MultiChildRenderObjectElement extends Element {
  @override
  late Widget widget;

  @override
  void mount(Element? parent, Object? newSlot) {
    super.mount(parent, newSlot);
    final List<Element> children =
        List<Element>.filled(widget.children.length, _NullElement.instance);
    Element? previousChild;
    for (int i = 0; i < children.length; i += 1) {
      final Element newChild =
          inflateWidget(children[i], IndexedSlot<Element?>(i, previousChild));
      children[i] = newChild;
      previousChild = newChild;
    }
    _children = children;
  }
}

class _NullElement extends Element {
  _NullElement() : super(const _NullWidget());

  static _NullElement instance = _NullElement();

  @override
  bool get debugDoingBuild => throw UnimplementedError();
}

class _NullWidget extends Widget {
  const _NullWidget();

  @override
  Element createElement() => throw UnimplementedError();
}
 */