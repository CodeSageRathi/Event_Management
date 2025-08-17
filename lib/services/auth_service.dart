import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthService with ChangeNotifier {
  final SharedPreferences prefs;
  User? _currentUser;

  AuthService({required this.prefs}) {
    _loadUserFromPrefs();
  }

  bool get isAuthenticated => _currentUser != null;
  User? get currentUser => _currentUser;

  void _loadUserFromPrefs() {
    final email = prefs.getString('userEmail');
    if (email != null) {
      _currentUser = User(email: email);
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    // Dummy validation
    if (email.isNotEmpty && password.isNotEmpty) {
      _currentUser = User(email: email);
      await prefs.setString('userEmail', email);
      notifyListeners();
    } else {
      throw Exception('Invalid credentials');
    }
  }

  Future<void> signup(String email, String password) async {
    // Dummy signup
    _currentUser = User(email: email);
    await prefs.setString('userEmail', email);
    notifyListeners();
  }

  Future<void> logout() async {
    _currentUser = null;
    await prefs.remove('userEmail');
    notifyListeners();
  }
}
