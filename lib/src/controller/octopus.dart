import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../route/octopus_route.dart';
import '../state/octopus_state.dart';
import 'octopus_delegate.dart';

/// {@template octopus}
///
/// {@endtemplate}
abstract class Octopus {
  factory Octopus({required List<OctopusRoute> routes}) = OctopusImpl;
  abstract final RouterConfig<OctopusState> config;
}

/// {@nodoc}
@sealed
@internal
class OctopusImpl implements Octopus {
  factory OctopusImpl({required List<OctopusRoute> routes}) {
    final delegate = OctopusDelegate();
    return OctopusImpl._(
      delegate: delegate,
    );
  }

  OctopusImpl._({
    required RouterDelegate<OctopusState> delegate,
  }) : config = RouterConfig<OctopusState>(routerDelegate: delegate);

  @override
  final RouterConfig<OctopusState> config;
}
