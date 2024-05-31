import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class PaymentMethodProvider with ChangeNotifier {
  static const _phoneNumberKey = 'phoneNumber';
  final _box = GetStorage();

  String? get phoneNumber => _box.read(_phoneNumberKey);

  Future<void> loadPhoneNumber() async {
    // No action needed, as we can directly read from the box
    notifyListeners();
  }

  Future<void> savePhoneNumber(String phoneNumber) async {
    await _box.write(_phoneNumberKey, phoneNumber);
    notifyListeners();
  }

  void clearPhone() {
    _box.remove(_phoneNumberKey);
    notifyListeners();
  }
}
