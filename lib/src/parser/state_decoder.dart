import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../state/octopus_state.dart';

/// Converts [OctopusState] to [RouteInformation].
class OctopusStateDecoder extends Converter<OctopusState, RouteInformation> {
  /// Converts [OctopusState] to [RouteInformation].
  const OctopusStateDecoder();

  @override
  RouteInformation convert(OctopusState input) {
    // TODO: implement convert
    throw UnimplementedError();
  }
}
