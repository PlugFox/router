import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:octopus/src/parser/information_parser.dart';
import 'package:octopus/src/route/octopus_route.dart';
import 'package:octopus/src/state/octopus_state.dart';

import '../route/fake_routes.dart';

void main() => group('InformationParser', () {
      late RouteInformationParser<OctopusState> parser;
      Future<OctopusState> parseLocation(String location) =>
          parser.parseRouteInformation(RouteInformation(location: location));

      setUpAll(() {
        parser = OctopusInformationParser(
          routes: FakeRoutes.values.map<OctopusRoute>((e) => e.route).toList(),
        );
      });

      test('parse_root', () {
        const location = '/';
        expect(
          () => parseLocation(location),
          returnsNormally,
        );
        expectLater(
          parseLocation(location),
          completion(isNotEmpty),
        );
        expectLater(
          parseLocation(location),
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
