import 'dart:convert';

import 'package:flutter/widgets.dart';

import '../route/octopus_route.dart';
import '../state/octopus_state.dart';
import 'state_decoder.dart';
import 'state_encoder.dart';

/// Converts [RouteInformation] to [OctopusState] and vice versa.
class OctopusStateCodec extends Codec<RouteInformation, OctopusState> {
  /// Converts [RouteInformation] to [OctopusState] and vice versa.
  OctopusStateCodec(Iterable<OctopusRoute> routes)
      : encoder = OctopusStateEncoder(routes),
        decoder = const OctopusStateDecoder();

  @override
  final Converter<RouteInformation, OctopusState> encoder;

  @override
  final Converter<OctopusState, RouteInformation> decoder;
}
