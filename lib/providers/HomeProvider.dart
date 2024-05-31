import 'dart:convert';
import 'package:ecomerce/Models/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:ecomerce/models/category_model.dart';

import 'package:ecomerce/models/promotion_model.dart';
import 'package:ecomerce/utils/constants.dart';

class HomeProvider with ChangeNotifier {
  String _currentLocation = 'Somalia, Mogadishu';
  String get currentLocation => _currentLocation;

  TextEditingController _searchController = TextEditingController();
  TextEditingController get searchController => _searchController;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;

  List<String> imgList = [
    'assets/s1.jpg',
    'assets/s2.jpg',
    'assets/s3.jpg',
    'assets/s4.jpg'
  ];

  final int endTime =
      DateTime.now().millisecondsSinceEpoch + 1000 * 60 * 60 * 2;
  int _selectedSegment = 0;
  int get selectedSegment => _selectedSegment;

  List<String> menuItems = ['All', 'Trending', 'Newest', 'Popular'];

  List<Category> categoryList = [];
  List<Product> productList = [];
  List<Promotion> promotionList = [];
  bool isCategoryLoading = true;
  bool isProductLoading = true;
  bool isPromotionLoading = true;

  final String baseUrl = kEndpoint;

  HomeProvider() {
    fetchCategories();
    fetchProducts();
    fetchPromotions();
  }

  Future<void> fetchCategories() async {
    isCategoryLoading = true;
    notifyListeners();
    final response = await http.get(Uri.parse('$baseUrl/categories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      categoryList = data.map((json) => Category.fromJson(json)).toList();
    } else {
      // Handle error
    }
    isCategoryLoading = false;
    notifyListeners();
  }

  Future<void> fetchProducts([String? filter]) async {
    isProductLoading = true;
    productList.clear();
    notifyListeners();

    String url = '$baseUrl/productsr';
    if (filter != null) {
      switch (filter) {
        case 'trendings':
          url += '/trendings';
          break;
        case 'newests':
          url += '/newests';
          break;
        case 'populars':
          url += '/populars';
          break;
        default:
          break;
      }
    }

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      productList = data.map((json) => Product.fromJson(json)).toList();
      // print(
      //     "data prduct................................................................");
      // print(data);
    } else {
      // Handle error
    }
    isProductLoading = false;
    notifyListeners();
  }

  Future<void> fetchPromotions() async {
    isPromotionLoading = true;
    notifyListeners();

    final response = await http.get(Uri.parse('$baseUrl/promotions'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      promotionList = data.map((json) => Promotion.fromJson(json)).toList();
    } else {
      // Handle error
    }
    isPromotionLoading = false;
    notifyListeners();
  }

  void updateLocation(String location) {
    _currentLocation = location;
    notifyListeners();
  }

  void setCurrentIndex(int index) {
    _currentIndex = index;
    notifyListeners();
  }
}
