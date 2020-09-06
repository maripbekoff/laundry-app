import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = FlutterSecureStorage();

  Future<String> get readAuthToken async {
    final String authtoken = await _storage.read(key: 'authtoken') ?? null;
    return authtoken;
  }

  Future<void> writeAuthToken({@required String value}) async {
    await _storage.write(key: 'authtoken', value: value);
  }

  Future<void> removeAuthToken() async {
    await _storage.delete(key: 'authtoken');
  }

  Future<String> get readCartItems async {
    final String cartItems = await _storage.read(key: 'cartItems');
    return cartItems;
  }

  Future<void> writeCartItems({@required String value}) async {
    await _storage.write(key: 'cartItems', value: value);
  }

   Future<void> removeCartItems() async {
    await _storage.delete(key: 'cartItems');
  }
}
