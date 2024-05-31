import 'package:ecomerce/Models/order.dart';
import 'package:ecomerce/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderProvider with ChangeNotifier {
  final GetStorage _storage = GetStorage();
  final String baseUrl = kEndpoint;
  String? _phoneNumber;
  String? _address;
  List<Order> _orders = [];
  bool _isLoading = false;
  bool _hasError = false;

  String? get phoneNumber => _phoneNumber;
  String? get address => _address;
  List<Order> get orders => _orders;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;

  OrderProvider() {
    _loadUserData();
  }

  void _loadUserData() {
    _phoneNumber = _storage.read('phoneNumber');
    _address = _storage.read('address');
    notifyListeners();
  }

  void savePhoneNumber(String phone) {
    _phoneNumber = phone;
    _storage.write('phoneNumber', phone);
    notifyListeners();
  }

  void saveAddress(String address) {
    _address = address;
    _storage.write('address', address);
    notifyListeners();
  }

  Future<void> registerOrder(Map<String, dynamic> orderData) async {
    final url = Uri.parse('$baseUrl/orders');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(orderData),
      );

      if (response.statusCode == 201) {
        notifyListeners();
      } else {
        throw Exception('Failed to register order: ${response.body}');
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> fetchOrdersByUserId(String userId) async {
    final url = Uri.parse('$baseUrl/orders/user/$userId');
    _isLoading = true;
    _hasError = false;
    notifyListeners();

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _orders = data.map((json) => Order.fromJson(json)).toList();
      } else {
        _hasError = true;
      }
    } catch (error) {
      _hasError = true;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
