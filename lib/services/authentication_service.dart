import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:send_money_app/models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  bool _isLoggedIn = false;
  String _userId = '';
  User? _currentUser;

  Future<void> initialize() async {
    await loadUserFromLocalStorage();
  }

  Future<bool> login(String username, String password) async {
    try {
      await Future.delayed(const Duration(milliseconds: 500));

      final response = await http.get(
        Uri.parse('https://67911595af8442fd7378f856.mockapi.io/api/user'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> users = json.decode(response.body);

        for (var userData in users) {
          final user = User.fromJson(userData);

          if (user.username == username && user.password == password) {
            _isLoggedIn = true;
            _userId = user.userId;
            _currentUser = user;

            await _saveUserToLocalStorage(user);
            return true;
          }
        }
      }
    } catch (e) {
      debugPrint('Login Error: $e');
    }

    _isLoggedIn = false;
    return false;
  }

  Future<void> logout() async {
    _isLoggedIn = false;
    _userId = '';
    _currentUser = null;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  bool get isLoggedIn => _isLoggedIn;
  String get userId => _userId;
  User? get currentUser => _currentUser;

  Future<void> _saveUserToLocalStorage(User user) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', true);
    prefs.setString('user', json.encode(user.toJson()));
  }

  Future<void> loadUserFromLocalStorage() async {
    final prefs = await SharedPreferences.getInstance();

    if (prefs.getBool('isLoggedIn') ?? false) {
      final userData = prefs.getString('user');

      if (userData != null) {
        _currentUser = User.fromJson(json.decode(userData));
        _isLoggedIn = true;
        _userId = _currentUser!.userId;
      }
    }
  }
}
