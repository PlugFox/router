import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';

import '../state/octopus_state.dart';
import 'octopus.dart';
import 'octopus_delegate.dart';

/// {@nodoc}
@internal
class OctopusImpl implements Octopus {
  factory OctopusImpl() {
    final delegate = OctopusDelegate();
    return OctopusImpl._(
      delegate: delegate,
    );
  }

  OctopusImpl._({
    required RouterDelegate<OctopusState> delegate,
  }) : config = RouterConfig<OctopusState>(routerDelegate: delegate);

  @override
  RouterConfig<OctopusState> config;
}
