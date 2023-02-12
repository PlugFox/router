import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:octopus/octopus.dart';

/// {@template octopus_state_observer}
/// OctopusStateObserver widget.
/// {@endtemplate}
class OctopusStateObserver extends StatelessWidget {
  /// {@macro octopus_state_observer}
  const OctopusStateObserver({
    required this.observer,
    required this.child,
    super.key,
  });

  final ValueListenable<OctopusState> observer;

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          Positioned.fill(child: child),
          Positioned.fill(
            child: Overlay(
              initialEntries: <OverlayEntry>[
                OverlayEntry(
                  builder: (context) => Padding(
                    padding: EdgeInsets.only(
                      top: MediaQuery.paddingOf(context).top + 4,
                      right: 4,
                    ),
                    child: const _OctopusStateObserver$Button(),
                  ),
                ),
              ],
            ),
          ),
        ],
      );
}

class _OctopusStateObserver$Button extends StatefulWidget {
  const _OctopusStateObserver$Button();

  @override
  State<_OctopusStateObserver$Button> createState() =>
      __OctopusStateObserver$ButtonState();
}

/// State for widget _OctopusStateObserver$Button.
class __OctopusStateObserver$ButtonState
    extends State<_OctopusStateObserver$Button> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  void _showTooltip(OverlayState overlay) {
    _hideTooltip();
    overlay.insert(
      _overlayEntry = OverlayEntry(
        builder: (context) => Align(
          alignment: Alignment.topRight,
          child: CompositedTransformFollower(
            link: _layerLink,
            offset: const Offset(-4, 8),
            targetAnchor: Alignment.bottomRight,
            followerAnchor: Alignment.topRight,
            showWhenUnlinked: false,
            child: Material(
              color: Colors.black.withOpacity(0.25),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                child: ValueListenableBuilder<OctopusState>(
                  valueListenable: context
                      .findAncestorWidgetOfExactType<OctopusStateObserver>()!
                      .observer,
                  builder: (context, state, _) => Text(
                    state.toStringDeep(),
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      height: 1,
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _hideTooltip() {
    if (_overlayEntry == null) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  Widget build(BuildContext context) => Align(
        alignment: Alignment.topRight,
        child: Material(
          color: Colors.black.withOpacity(0.25),
          shape: const CircleBorder(),
          child: SizedBox.square(
            dimension: 48,
            child: CompositedTransformTarget(
              link: _layerLink,
              child: ValueListenableBuilder<OctopusState>(
                valueListenable: context
                    .findAncestorWidgetOfExactType<OctopusStateObserver>()!
                    .observer,
                builder: (context, state, _) => StatefulBuilder(
                    builder: (context, setState) => IconButton(
                          splashRadius: 24,
                          iconSize: 32,
                          icon: AnimatedCrossFade(
                            duration: const Duration(milliseconds: 250),
                            crossFadeState: _overlayEntry != null
                                ? CrossFadeState.showFirst
                                : CrossFadeState.showSecond,
                            firstChild: const Icon(
                              Icons.close_outlined,
                            ),
                            secondChild: const Icon(
                              Icons.info_outline,
                              key: ValueKey('icon#info'),
                            ),
                          ),
                          onPressed: () => setState(
                            () => _overlayEntry != null
                                ? _hideTooltip()
                                : _showTooltip(Overlay.of(context)),
                          ),
                        )),
              ),
            ),
          ),
        ),
      );
}
