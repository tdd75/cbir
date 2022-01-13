import 'package:flutter/foundation.dart';

import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String productId;
  final String productName;
  final String productImage;
  final double productPrice;
  final int productDiscount;
  final double ratingStar;
  final int sold;
  final bool isFreeship;
  final String shopLocation;
  final String category;
  bool isFavorite;

  Product(
    this.productId,
    this.productName,
    this.productImage,
    this.productPrice,
    this.productDiscount,
    this.ratingStar,
    this.sold,
    this.isFreeship,
    this.shopLocation,
    this.category, {
    this.isFavorite = false,
  });

  // Future<void> toggleFavoriteStatus(String token, String userId) async {
  //   isFavorite = !isFavorite;
  //   notifyListeners();
  //   // var url = Uri.parse(
  //   //     'https://shop-app-d7e86-default-rtdb.asia-southeast1.firebasedatabase.app/products/$id.json?auth=$token');
  //   var url = Uri.parse(
  //       'https://shop-app-d7e86-default-rtdb.asia-southeast1.firebasedatabase.app/userFavorites/$userId/$id.json?auth=$token');
  //   try {
  //     final response = await http.put(url,
  //         body: json.encode({
  //           isFavorite,
  //         }));
  //     if (response.statusCode > 400) {
  //       isFavorite = !isFavorite;
  //       notifyListeners();
  //     }
  //   } catch (error) {
  //     isFavorite = !isFavorite;
  //     notifyListeners();
  //   }
  // }
}
