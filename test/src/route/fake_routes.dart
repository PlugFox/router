// @dart = 3.0

import 'package:flutter/material.dart';
import 'package:octopus/octopus.dart';

enum FakeRoutes implements OctopusRoute {
  shop(ShopRoute()),
  category(CategoryRoute()),
  product(ProductRoute());

  const FakeRoutes(this._route);

  final OctopusRoute _route;

  @override
  String get name => _route.name;
}

class ShopRoute extends OctopusRoute$Page {
  const ShopRoute() : super('Shop');

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
