import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:octopus/octopus.dart';
import 'package:octopus/src/parser/information_parser.dart';

import '../route/fake_routes.dart';

void main() => group('parser', () {
      late RouteInformationParser<OctopusState> parser;

      setUpAll(() {
        parser = OctopusInformationParser(routes: FakeRoutes.values);
      });

      test('parseRouteInformation_root', () {
        const location = '/';
        const routeInformation = RouteInformation(location: location);
        expect(
          () => parser.parseRouteInformation(routeInformation),
          returnsNormally,
        );
      });
    });
