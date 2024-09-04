import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../services/connectivity.dart';

class AuthController extends GetxController {
  final _token = RxString('');
  String get token => _token.value;

  final _storage = const FlutterSecureStorage();
  final ConnectivityService _connectivityService = Get.put(ConnectivityService());

  @override
  void onInit() {
    super.onInit();
    loadToken();
  }

  Future<void> loadToken() async {
    String? storedToken = await _storage.read(key: 'auth_token');
    if (storedToken != null) {
      _token.value = storedToken;
    }
  }

  Future<bool> login(String username, String password) async {
    if (!await _connectivityService.checkConnection()) return false;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:80/api/token/'),
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        _token.value = data['access'];
        await _storage.write(key: 'auth_token', value: _token.value);
        return true;
      } else if (response.statusCode == 401) {
        return register(username, password);
      } else {
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  Future<bool> register(String username, String password) async {
    if (!await _connectivityService.checkConnection()) return false;

    try {
      final response = await http.post(
        Uri.parse('http://localhost:80/api/register/'),
        body: {'username': username, 'password': password},
      );

      if (response.statusCode == 200) {
        return login(username, password);
      } else {
        throw Exception('Failed to register');
      }
    } catch (e) {
      print('Registration error: $e');
      return false;
    }
  }

  Future<bool> checkToken() async {
    if (_token.value.isEmpty) {
      return false;
    }
    return true;
  }

  Future<void> logout() async {
    _token.value = '';
    await _storage.delete(key: 'auth_token');
  }
}
