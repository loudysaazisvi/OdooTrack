import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _isAuthenticated = false;
  String _nickname = 'User';

  bool get isAuthenticated => _isAuthenticated;
  String get nickname => _nickname;

  // Mock login function
  Future<bool> login(String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    if (email.isNotEmpty && password.isNotEmpty) {
      _isAuthenticated = true;
      // Mock nickname from email if we don't have one
      _nickname = email.split('@').first;
      // Capitalize first letter
      if (_nickname.isNotEmpty) {
        _nickname = _nickname[0].toUpperCase() + _nickname.substring(1);
      }
      notifyListeners();
      return true;
    }
    return false;
  }

  // Mock register function
  Future<bool> register(String name, String email, String password) async {
    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    if (name.isNotEmpty && email.isNotEmpty && password.isNotEmpty) {
      _isAuthenticated = true;
      _nickname = name.split(' ').first; // Take first name as nickname
      notifyListeners();
      return true;
    }
    return false;
  }

  void logout() {
    _isAuthenticated = false;
    notifyListeners();
  }
}
