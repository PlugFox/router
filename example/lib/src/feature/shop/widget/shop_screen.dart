import 'package:flutter/material.dart';
import 'package:octopus/octopus.dart';

import '../../../common/router/routes.dart';

/// {@template shop_screen}
/// ShopScreen widget.
/// {@endtemplate}
class ShopScreen extends StatelessWidget {
  /// {@macro shop_screen}
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: const Text('Shop'),
        ),
        body: SafeArea(
          child: Center(
            child: ElevatedButton(
              onPressed: () =>
                  Octopus.instance.setState((state) => state.copyWith(
                        newChildren: <OctopusNode>[
                          ...state.children,
                          OctopusNode.page(
                            Routes.category.route,
                            arguments: const {'id': 'electronic'},
                          )
                        ],
                      )),
              child: const Text('Go to category'),
            ),
          ),
        ),
      );
}
