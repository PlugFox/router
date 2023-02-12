import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:octopus/src/parser/state_encoder.dart';
import 'package:octopus/src/route/octopus_route.dart';
import 'package:octopus/src/state/octopus_node.dart';
import 'package:octopus/src/state/octopus_state.dart';

import '../route/fake_routes.dart';

void main() => group('StateEncoder', () {
      late OctopusStateEncoder encoder;

      setUpAll(() {
        final routes = FakeRoutes.values.map<OctopusRoute>((e) => e.route);
        encoder = OctopusStateEncoder(routes);
      });

      test('routeFromSegment', () {
        expect(
          () => encoder.nodeFromSegment('shop'),
          returnsNormally,
        );
        expect(
          encoder.nodeFromSegment('unknown-route'),
          isNull,
        );
        expect(
          encoder.nodeFromSegment('shop'),
          isNotNull,
        );
        expect(
          encoder.nodeFromSegment('category--id(electronic)'),
          allOf(
            isA<OctopusNode>().having(
              (s) => s.route,
              'route',
              equals(FakeRoutes.category.route),
            ),
            isA<OctopusNode>().having(
              (s) => s.route.key,
              'key',
              equals('category'),
            ),
            isA<OctopusNode>().having(
              (s) => s.arguments,
              'arguments',
              isA<Map<String, String>>().having(
                (s) => s['id'],
                'id',
                equals('electronic'),
              ),
            ),
          ),
        );
        expect(
          encoder.nodeFromSegment(
            'Gift-Vouchers'
            '--title(Mobile phone)'
            '--Tag Color (TagColor%28+%237CFC00+%29)'
            '--Order_By(price)'
            '--Description()'
            '--(true)',
          ),
          allOf(
            isA<OctopusNode>().having(
              (s) => s.route,
              'route',
              equals(FakeRoutes.giftVouchers.route),
            ),
            isA<OctopusNode>().having(
              (s) => s.route.key,
              'key',
              equals('gift-vouchers'),
            ),
            isA<OctopusNode>().having(
              (s) => s.arguments,
              'arguments',
              allOf(
                isA<Map<String, String>>().having(
                  (s) => s.isNotEmpty,
                  'isNotEmpty',
                  isTrue,
                ),
                isA<Map<String, String>>().having(
                  (s) => s['title'],
                  'title',
                  equals('Mobile phone'),
                ),
                isA<Map<String, String>>().having(
                  (s) => s['tag-color'],
                  'tag-color',
                  equals('TagColor( #7CFC00 )'),
                ),
                isA<Map<String, String>>().having(
                  (s) => s['order-by'],
                  'order-by',
                  equals('price'),
                ),
                isA<Map<String, String>>().having(
                  (s) => s['description'],
                  'description',
                  isEmpty,
                ),
                isA<Map<String, String>>().having(
                  (s) => s[''],
                  'flag',
                  'true',
                ),
              ),
            ),
          ),
        );
      });

      test('nodesFromUri', () {
        final uri = Uri.tryParse('/shop'
            '/Gift-Vouchers--Order_By(price)--(true)'
            '/Unknown-route--k(v)'
            '/Category--ID(electronic)'
            '/Category--id(smartphone)'
            '/product--type(Mobile phone)--id(5)--degree-of-protection(IP68)');
        expect(
          () => encoder.nodesFromUri(null),
          returnsNormally,
        );
        expect(
          () => encoder.nodesFromUri(Uri.parse('/').pathSegments),
          returnsNormally,
        );
        expect(
          () => encoder.nodesFromUri(uri?.pathSegments),
          returnsNormally,
        );
        expect(
          encoder.nodesFromUri(uri?.pathSegments),
          isA<List<OctopusNode>>().having(
            (s) => s,
            'list',
            allOf(
              isNotEmpty,
              hasLength(5),
              everyElement(
                isA<OctopusNode>().having(
                  (s) => s.route,
                  'route',
                  isNotNull,
                ),
              ),
              anyElement(
                isA<OctopusNode>().having(
                  (s) => s.arguments['order-by'],
                  'OrderBy=price',
                  equals('price'),
                ),
              ),
              anyElement(
                isA<OctopusNode>().having(
                  (s) => s.arguments['id'],
                  'id=electronic',
                  equals('electronic'),
                ),
              ),
            ),
          ),
        );
      });

      test('convert', () {
        const location = '/shop'
            '/Gift-Vouchers--Order_By(price)--(true)'
            '/Unknown-route--k(v)'
            '/Category--ID(electronic)'
            '/Category--id(smartphone)'
            '/product--type(Mobile phone)--id(5)--Degree-Of-Protection(IP68)';
        expect(
          () => encoder.convert(const RouteInformation()),
          returnsNormally,
        );
        expect(
          () => encoder.convert(const RouteInformation(location: '')),
          returnsNormally,
        );
        expect(
          () => encoder.convert(const RouteInformation(location: '/')),
          returnsNormally,
        );
        expect(
          () => encoder.convert(const RouteInformation(location: location)),
          returnsNormally,
        );
        expect(
          encoder.convert(const RouteInformation(location: '/')),
          allOf(
            isNotEmpty,
            isA<OctopusState>().having(
              (s) => s.first.route,
              'route',
              FakeRoutes.values.first.route,
            ),
            hasLength(1),
          ),
        );
        expect(
          encoder.convert(const RouteInformation(location: location)),
          allOf(
            isA<OctopusStateImpl>(),
            isNotEmpty,
            everyElement(
              isA<OctopusNode>().having(
                (s) => s.route,
                'route',
                isNotNull,
              ),
            ),
            anyElement(
              isA<OctopusNode>().having(
                (s) => s.arguments['degree-of-protection'],
                'DegreeOfProtection=IP68',
                equals('IP68'),
              ),
            ),
          ),
        );
      });
    });
