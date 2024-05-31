import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';
import 'package:ecomerce/Models/product.dart';

class WishlistProvider with ChangeNotifier {
  List<Product> _wishlist = [];
  final GetStorage _box = GetStorage();

  List<Product> get wishlist => _wishlist;

  WishlistProvider() {
    loadWishlist();
  }

  void addToWishlist(Product product) {
    _wishlist.add(product);
    saveWishlist();
    notifyListeners();
  }

  void removeFromWishlist(Product product) {
    _wishlist.removeWhere((item) => item.id == product.id);
    saveWishlist();
    notifyListeners();
  }

  bool isInWishlist(Product product) {
    return _wishlist.any((item) => item.id == product.id);
  }

  void saveWishlist() {
    List<String> wishlistJson =
        _wishlist.map((product) => jsonEncode(product.toJson())).toList();
    _box.write('wishlist', wishlistJson);
  }

  void loadWishlist() {
    List<dynamic>? wishlistJson = _box.read<List<dynamic>>('wishlist');
    if (wishlistJson != null) {
      _wishlist = wishlistJson
          .map((item) => Product.fromJson(jsonDecode(item)))
          .toList();
      notifyListeners();
    }
  }

  void clearWishList() {
    _wishlist.clear();
    _box.remove('wishlist');
    notifyListeners();
  }
}
