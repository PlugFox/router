import 'package:flutter/material.dart';

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
              onPressed: () {},
              child: const Text('Shop'),
            ),
          ),
        ),
      );
}
