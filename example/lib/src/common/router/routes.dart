// @dart = 3.0

import 'package:flutter/material.dart';
import 'package:octopus/octopus.dart';

import '../../feature/category/widget/category_screen.dart';
import '../../feature/product/widget/product_screen.dart';
import '../../feature/shop/widget/shop_screen.dart';

enum Routes with OctopusRouteOwner {
  shop(ShopRoute()),
  category(CategoryRoute()),
  product(ProductRoute());

  const Routes(this.route);

  @override
  final OctopusRoute route;
}

class ShopRoute extends OctopusRoute$Page {
  const ShopRoute() : super('Shop');

  @override
  Page<void> buildPage(BuildContext context, Map<String, String> arguments) =>
      MaterialPage<void>(
        key: ValueKey<String>(name),
        child: const ShopScreen(),
      );
}

class CategoryRoute extends OctopusRoute$Page {
  const CategoryRoute() : super('Category');

  @override
  Page<void> buildPage(BuildContext context, Map<String, String> arguments) {
    final id = arguments['id'];
    return MaterialPage<void>(
      key: ValueKey<String>('$name@id=$id'),
      child: CategoryScreen(
        id: id,
      ),
    );
  }
}

class ProductRoute extends OctopusRoute$Page {
  const ProductRoute() : super('Product');

  @override
  Page<void> buildPage(BuildContext context, Map<String, String> arguments) {
    final id = arguments['id'];
    return MaterialPage<void>(
      key: ValueKey<String>('$name@id=$id'),
      child: ProductScreen(
        id: id,
      ),
    );
  }
}
