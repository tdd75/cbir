import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:shop_app/widgets/product_item.dart';
// import './product_item.dart';
import '../providers/products.dart';

class ProductsGrid extends StatelessWidget {
  const ProductsGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items;

    return GridView.builder(
      padding: const EdgeInsets.all(0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 5 / 8,
        crossAxisSpacing: 8,
      ),
      itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: const ProductItem(),
      ),
      itemCount: products.length,
    );
  }
}
