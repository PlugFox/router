import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:octopus/src/error/error.dart';
import 'package:octopus/src/parser/state_decoder.dart';
import 'package:octopus/src/state/octopus_node.dart';
import 'package:octopus/src/state/octopus_state.dart';

import '../route/fake_routes.dart';

void main() => group('StateEncoder', () {
      late OctopusStateDecoder encoder;
      final nodes = <OctopusNode>[
        OctopusNode.page(
          FakeRoutes.shop.route,
        ),
        OctopusNode.page(
          FakeRoutes.giftVouchers.route,
          arguments: const <String, String>{
            'tiTle': 'Mobile phone',
            'Tag Color': 'TagColor( #7CFC00 )',
            'Order_By': 'price',
            'Description': '',
            '': 'true',
          },
        ),
        OctopusNode.page(
          FakeRoutes.category.route,
          arguments: const <String, String>{'ID': 'electronic'},
        ),
        OctopusNode.page(
          FakeRoutes.category.route,
          arguments: const <String, String>{'id': 'smartphone'},
        ),
        OctopusNode.page(
          FakeRoutes.product.route,
          arguments: const <String, String>{
            'type': 'Mobile phone',
            'id': '5',
            'degree of protection': 'IP68',
          },
        ),
      ];

      setUpAll(() {
        encoder = const OctopusStateDecoder();
      });

      test('segmentFromNode', () {
        expect(
          () => encoder.segmentFromNode(
            OctopusNode.page(FakeRoutes.shop.route),
          ),
          returnsNormally,
        );
        expect(
          encoder.segmentFromNode(
            OctopusNode.page(FakeRoutes.shop.route),
          ),
          isNotEmpty,
        );
        expect(
          encoder.segmentFromNode(
            OctopusNode.page(
              FakeRoutes.category.route,
              arguments: const <String, String>{'id': 'electronic'},
            ),
          ),
          allOf(
            isNotEmpty,
            equals('category--id(electronic)'),
          ),
        );
        expect(
          encoder.segmentFromNode(
            OctopusNode.page(
              FakeRoutes.giftVouchers.route,
              arguments: const <String, String>{
                'tiTle': 'Mobile phone',
                'Tag Color': 'TagColor( #7CFC00 )',
                'Order_By': 'price',
                'Description': '',
                '': 'true',
              },
            ),
          ),
          allOf(
            isNotEmpty,
            equals(
              'gift-vouchers'
              '--title(Mobile+phone)'
              '--tag-color(TagColor%28+%237CFC00+%29)'
              '--order-by(price)'
              '--description()--(true)',
            ),
          ),
        );
      });

      test('uriFromNodes', () {
        expect(
          () => encoder.uriFromNodes([]),
          returnsNormally,
        );
        expect(
          () => encoder.uriFromNodes(nodes),
          returnsNormally,
        );
        expect(
          encoder.uriFromNodes([]),
          isNull,
        );
        expect(
          encoder.uriFromNodes(nodes),
          allOf(
            isA<List<String>>(),
            isNotEmpty,
            hasLength(5),
            everyElement(isNotEmpty),
          ),
        );
      });

      test('convert', () {
        final state = OctopusState(children: nodes);
        expect(
          () => encoder.convert(OctopusState.single(nodes.first)),
          returnsNormally,
        );
        expect(
          () => encoder.convert(InvalidOctopusState(
            OctopusEncodeException(exception: Exception('Sample')),
            StackTrace.empty,
          )),
          returnsNormally,
        );
        expect(
          () => encoder.convert(state),
          returnsNormally,
        );
        expect(
          encoder.convert(state),
          isA<RouteInformation>().having(
            (route) => route.location,
            'location',
            allOf(
              isNotEmpty,
              startsWith('/shop'),
            ),
          ),
        );
      });
    });
