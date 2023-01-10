import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../state/octopus_state.dart';
import '../widget/inherited_octopus.dart';

class OctopusDelegate extends RouterDelegate<OctopusState> with ChangeNotifier {
  OctopusState? _currentConfiguration;

  @override
  OctopusState get currentConfiguration {
    final state = _currentConfiguration;
    if (state == null) throw UnsupportedError('Initial configuration not set');
    return state;
  }

  NavigatorState? get navigator => _modalObserver.navigator;
  final NavigatorObserver _modalObserver = RouteObserver<ModalRoute<Object?>>();

  @override
  Future<void> setNewRoutePath(covariant OctopusState configuration) {
    // If unchanged, do nothing
    //if (_currentConfiguration == configuration) return SynchronousFuture<void>(null);

    // ignore: todo
    // TODO: check if the new configuration is valid
    // exclude duplicates
    // Matiunin Mikhail <plugfox@gmail.com>, 06 December 2022
    _currentConfiguration = configuration;
    notifyListeners();

    // Use [SynchronousFuture] so that the initial url is processed
    // synchronously and remove unwanted initial animations on deep-linking
    return SynchronousFuture<void>(null);
  }

  @override
  Future<bool> popRoute() {
    final nav = navigator;
    assert(nav != null, 'Navigator is not attached to the OctopusDelegate');
    if (nav == null) return SynchronousFuture<bool>(false);
    return nav.maybePop();
  }

  @override
  Widget build(BuildContext context) => Inheritedoctopus(
        child: Navigator(
          reportsRouteUpdateToEngine: true,
          observers: <NavigatorObserver>[
            _modalObserver,
            // TODO: Additional observers from the [Octopus] class
            // Matiunin Mikhail <plugfox@gmail.com>, 10 January 2023
          ],
          pages: const <Page<Object?>>[
            // TODO: Pages from the current [OctopusState]
            // Matiunin Mikhail <plugfox@gmail.com>, 10 January 2023
          ],
          onPopPage: _onPopPage,
          // TODO: restorationScopeId: restorationScopeId,
          // TODO: transitionDelegate: throw UnimplementedError(),
          // TODO: onUnknownRoute: _onUnknownRoute,
        ),
      );

  bool _onPopPage(Route<Object?> route, Object? result) {
    if (!route.didPop(result)) return false;
    final popped = _currentConfiguration?.maybePop();
    if (popped == null) return false;
    setNewRoutePath(popped);
    return true;
  }
}
