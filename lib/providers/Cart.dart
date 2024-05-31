import 'package:ecomerce/Models/product.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class CartProvider with ChangeNotifier {
  List<CartItem> _items = [];
  final GetStorage _storage = GetStorage();

  CartProvider() {
    _loadCart();
  }

  List<CartItem> get items => _items;

  void addToCart(Product product) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _items[index].quantity += 1;
    } else {
      _items.add(CartItem(product: product, quantity: 1));
    }
    _saveCart();
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _items.removeWhere((item) => item.product.id == product.id);
    _saveCart();
    notifyListeners();
  }

  void updateQuantity(Product product, int quantity) {
    final index = _items.indexWhere((item) => item.product.id == product.id);
    if (index != -1) {
      _items[index].quantity = quantity;
      _saveCart();
      notifyListeners();
    }
  }

  double get totalAmount {
    double total = 0.0;
    for (var item in _items) {
      total += item.product.price! * item.quantity;
    }
    return total;
  }

  void _saveCart() {
    final List<Map<String, dynamic>> cartData =
        _items.map((item) => item.toJson()).toList();
    _storage.write('cart', cartData);
  }

  void _loadCart() {
    final List<dynamic> cartData = _storage.read('cart') ?? [];

    _items = cartData
        .map((item) => CartItem.fromJson(item as Map<String, dynamic>))
        .toList();
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    _storage.remove('cart');
    notifyListeners();
  }
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, required this.quantity});

  Map<String, dynamic> toJson() => {
        'product': product.toJson(),
        'quantity': quantity,
      };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
        product: Product.fromJson(json['product']),
        quantity: json['quantity'],
      );
}
