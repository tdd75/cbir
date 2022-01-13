import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/product.dart';
import 'package:intl/intl.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key}) : super(key: key);

  String _convertSold(sold) {
    if (sold >= 1000) {
      return (sold / 1000).toString().replaceAll('.', ',') + 'k';
    } else {
      return sold.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);

    final _formatCurrency =
        NumberFormat.currency(symbol: "đ", decimalDigits: 0);

    return GestureDetector(
      onTap: () {},
      child: Column(
        children: [
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            width: double.infinity,
            height: 150,
            child: Hero(
              tag: product.productId,
              child: FadeInImage(
                placeholder: const AssetImage('assets/images/logo.png'),
                image: NetworkImage(product.productImage),
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          Container(
            decoration: const BoxDecoration(color: Colors.white),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                const SizedBox(height: 10),
                Text(
                  product.productName,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      _formatCurrency.format(product.productPrice.toInt()),
                      style: const TextStyle(
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    Text(
                      ' ' +
                          _formatCurrency.format(product.productPrice.toInt()),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    RatingBar.builder(
                      initialRating: product.ratingStar,
                      itemBuilder: (context, _) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      itemSize: 12,
                      onRatingUpdate: (_) {},
                    ),
                    Text(
                      '  ${_convertSold(product.sold)} sold',
                      style: const TextStyle(fontSize: 11),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 12,
                          color: Colors.grey,
                        ),
                        Text(
                          product.shopLocation,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.favorite_outline,
                      color: Colors.red,
                      size: 15,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
