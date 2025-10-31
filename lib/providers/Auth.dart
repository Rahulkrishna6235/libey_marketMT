import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

class AuthProvider with ChangeNotifier {
  final Dio _dio = Dio();
  String? _token;
  Map<String, dynamic>? _userData;
  String? _username; // store username
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  Map<String, dynamic>? get userData => _userData;
  String? get token => _token;
  String? get username => _username;

  Future<bool> login(String username, String password) async {
    _isLoading = true;
    notifyListeners();

    const url = 'https://dummyjson.com/auth/login';

    try {
      final response = await _dio.post(
        url,
        data: {
          'username': username,
          'password': password,
          'expiresInMins': 30,
        },
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      _token = response.data['token'];
      _username = username; // save logged-in username
      _isLoading = false;
      notifyListeners();

      await fetchUserData();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Login failed: $e');
      return false;
    }
  }

  Future<void> fetchUserData() async {
    if (_token == null) return;

    const url = 'https://dummyjson.com/auth/me';

    try {
      final response = await _dio.get(
        url,
        options: Options(
          headers: {
            'Authorization': 'Bearer $_token',
            'Content-Type': 'application/json',
          },
        ),
      );

      _userData = response.data;
      notifyListeners();
      debugPrint('User profile: $_userData');
    } catch (e) {
      debugPrint('Fetch user failed: $e');
    }
  }

  void logout() {
    _token = null;
    _userData = null;
    _username = null;
    notifyListeners();
  }
}
