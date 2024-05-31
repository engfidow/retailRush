// category_provider.dart
import 'dart:convert';
import 'package:ecomerce/Models/Category_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../utils/constants.dart';

class CategoryProvider with ChangeNotifier {
  List<Category> _categoryList = [];
  bool _isLoading = true;

  List<Category> get categoryList => _categoryList;
  bool get isLoading => _isLoading;

  CategoryProvider() {
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    final response = await http.get(Uri.parse('$kEndpoint/categories'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      _categoryList = data.map((json) => Category.fromJson(json)).toList();
      _isLoading = false;
      notifyListeners();
    } else {
      // Handle error
      _isLoading = false;
      notifyListeners();
    }
  }
}
