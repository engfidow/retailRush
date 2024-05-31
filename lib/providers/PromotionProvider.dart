import 'package:ecomerce/Models/promotion_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PromotionProvider with ChangeNotifier {
  List<Promotion> _promotions = [];
  bool _isLoading = true;

  List<Promotion> get promotions => _promotions;
  bool get isLoading => _isLoading;

  Future<void> fetchPromotions() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(
          'https://retailrushserver-production.up.railway.app/api/promotions'));
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        _promotions = data.map((json) => Promotion.fromJson(json)).toList();
      }
    } catch (error) {
      print(error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
