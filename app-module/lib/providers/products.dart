import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shop_app/main.dart';
import 'package:shop_app/models/http_exception.dart';
import 'package:shop_app/providers/api.dart';

import 'product.dart';

class Products with ChangeNotifier {
  // final String? authToken;
  // final String? email;
  List<Product> _items = [];

  // Products(this.email, this._items);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.productId == id);
  }

  Future<void> fetchAndSetProducts(dynamic productsData) async {
    try {
      if (productsData == null) {
        final prefs = await SharedPreferences.getInstance();
        final token = json.decode(prefs.getString("userData")!)["token"];

        dynamic response = await Api.getAllProducts(token);
        productsData = response['data'];
      }

      List<Product> loadedProducts = [];
      productsData.forEach((prodData) {
        loadedProducts.add(Product(
          prodData['productId'].toString(),
          prodData['productName'],
          prodData['productImage'],
          prodData['productPrice'].toDouble(),
          prodData['productDiscount'],
          prodData['ratingStar'].toDouble(),
          prodData['sold'],
          prodData['isFreeship'],
          prodData['shopLocation'],
          prodData['category'],
        ));
      });

      _items = loadedProducts;

      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
