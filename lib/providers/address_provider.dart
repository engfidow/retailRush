import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

class AddressProvider with ChangeNotifier {
  static const _addressKey = 'addresses';
  final _box = GetStorage();

  List<Map<String, String>> get addresses {
    final data = _box.read(_addressKey) ?? [];
    return List<Map<String, String>>.from(
        data.map((item) => Map<String, String>.from(item)));
  }

  void loadAddresses() {
    notifyListeners();
  }

  void addAddress(Map<String, String> address) {
    final currentAddresses = addresses;
    currentAddresses.add(address);
    _box.write(_addressKey, currentAddresses);
    notifyListeners();
  }

  void editAddress(int index, Map<String, String> newAddress) {
    final currentAddresses = addresses;
    currentAddresses[index] = newAddress;
    _box.write(_addressKey, currentAddresses);
    notifyListeners();
  }

  void deleteAddress(int index) {
    final currentAddresses = addresses;
    currentAddresses.removeAt(index);
    _box.write(_addressKey, currentAddresses);
    notifyListeners();
  }

  void clearAdddress() {
    _box.remove(_addressKey);
    notifyListeners();
  }
}
