// @dart = 3.0

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:octopus/octopus.dart';

@sealed
sealed class Routes {
  Routes._();

  static const OctopusRoute shop = ShopRoute();
  static const OctopusRoute category = CategoryRoute();
  static const OctopusRoute product = ProductRoute();

  /// All routes in the app.
  static const Set<OctopusRoute> values = <OctopusRoute>{
    shop,
    category,
    product,
  };
}

class ShopRoute extends OctopusRoute$Page {
  const ShopRoute() : super('Shop');

  @override
  bool get isHome => true;

  @override
  Page<void> call(BuildContext context, Map<String, String> arguments) =>
      MaterialPage<void>(
        key: ValueKey<String>(name),
        child: const Text('Shop'),
      );
}

class CategoryRoute extends OctopusRoute$Page {
  const CategoryRoute() : super('Category');

  @override
  Page<void> call(BuildContext context, Map<String, String> arguments) {
    final id = arguments['id'];
    return MaterialPage<void>(
      key: ValueKey<String>('$name@id=$id'),
      child: const Text('Category'),
    );
  }
}

class ProductRoute extends OctopusRoute$Page {
  const ProductRoute() : super('Product');

  @override
  Page<void> call(BuildContext context, Map<String, String> arguments) {
    final id = arguments['id'];
    return MaterialPage<void>(
      key: ValueKey<String>('$name@id=$id'),
      child: const Text('Product'),
    );
  }
}
