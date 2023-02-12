// @dart = 3.0

import 'package:flutter/material.dart';
import 'package:octopus/octopus.dart';

enum FakeRoutes implements OctopusRouteOwner {
  shop(ShopRoute()),
  category(CategoryRoute()),
  product(ProductRoute()),
  giftVouchers(GiftVouchersRoute());

  const FakeRoutes(this.route);

  @override
  final OctopusRoute route;
}

class ShopRoute extends OctopusRoute$Page {
  const ShopRoute() : super('Shop');

  @override
  Page<void> buildPage(BuildContext context, Map<String, String> arguments) =>
      MaterialPage<void>(
        key: ValueKey<String>(key),
        child: const Text('Shop'),
      );
}

class CategoryRoute extends OctopusRoute$Page {
  const CategoryRoute() : super('Category');

  @override
  Page<void> buildPage(BuildContext context, Map<String, String> arguments) {
    final id = arguments['id'];
    return MaterialPage<void>(
      key: ValueKey<String>('$key@id=$id'),
      child: const Text('Category'),
    );
  }
}

class ProductRoute extends OctopusRoute$Page {
  const ProductRoute() : super('Product');

  @override
  Page<void> buildPage(BuildContext context, Map<String, String> arguments) {
    final id = arguments['id'];
    return MaterialPage<void>(
      key: ValueKey<String>('$key@id=$id'),
      child: const Text('Product'),
    );
  }
}

class GiftVouchersRoute extends OctopusRoute$Page {
  const GiftVouchersRoute() : super('Gift vouchers');

  @override
  Page<void> buildPage(BuildContext context, Map<String, String> arguments) {
    return MaterialPage<void>(
      key: ValueKey<String>(key),
      child: const Text('Gift vouchers'),
    );
  }
}
