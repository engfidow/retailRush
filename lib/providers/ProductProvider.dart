import 'dart:convert';
import 'package:ecomerce/Models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _productList = [];
  List<Product> _similarProducts = [];
  bool _isLoading = true;
  bool _isEmpty = false;

  List<Product> get productList => _productList;
  List<Product> get similarProducts => _similarProducts;
  bool get isLoading => _isLoading;
  bool get isEmpty => _isEmpty;

  Future<void> fetchProducts(String categoryId) async {
    _isLoading = true;
    _productList.clear();
    notifyListeners();

    final response =
        await http.get(Uri.parse('$kEndpoint/products/category/$categoryId'));

    if (response.statusCode == 200) {
      print(response.body);
      final List<dynamic> data = json.decode(response.body);
      _productList = data.map((json) => Product.fromJson(json)).toList();
      _isLoading = false;
      _isEmpty = _productList.isEmpty;
    } else {
      _isLoading = false;
      _isEmpty = true;
    }
    notifyListeners();
  }

  Future<void> fetchSimilarProducts(
      String categoryId, String currentProductId) async {
    _similarProducts.clear();
    notifyListeners();

    final response =
        await http.get(Uri.parse('$kEndpoint/products/category/$categoryId'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _similarProducts = data
          .map((json) => Product.fromJson(json))
          .where((product) => product.id != currentProductId)
          .toList();
    } else {
      // Handle error
    }
    notifyListeners();
  }

  Future<void> fetchAllProducts() async {
    _isLoading = true;
    _productList.clear();
    notifyListeners();

    final response = await http.get(Uri.parse('$kEndpoint/productsr'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _productList = data.map((json) => Product.fromJson(json)).toList();
      _isLoading = false;
      _isEmpty = _productList.isEmpty;
    } else {
      _isLoading = false;
      _isEmpty = true;
    }
    notifyListeners();
  }
}
