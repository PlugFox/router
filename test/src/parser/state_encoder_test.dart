import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:octopus/src/parser/state_encoder.dart';
import 'package:octopus/src/route/octopus_route.dart';
import 'package:octopus/src/state/octopus_state.dart';

import '../route/fake_routes.dart';

void main() => group('StateEncoder', () {
      late OctopusStateEncoder encoder;
      OctopusState encode(String location, [Object? state]) => encoder.convert(
            RouteInformation(
              location: location,
              state: state,
            ),
          );

      setUpAll(() {
        final routes = FakeRoutes.values.map<OctopusRoute>((e) => e.route);
        encoder = OctopusStateEncoder(routes);
      });

      test('parse_root', () {
        const location = '/';
        expect(
          () => encode(location),
          returnsNormally,
        );
        expectLater(
          encode(location),
          completion(isNotEmpty),
        );
        expectLater(
          encode(location),
          completion(
            isA<OctopusState>().having(
              (s) => s.first.route,
              'route',
              isA<OctopusRoute>().having(
                (r) => r.name,
                'name',
                FakeRoutes.values.first.name,
              ),
            ),
          ),
        );
      });
    });
