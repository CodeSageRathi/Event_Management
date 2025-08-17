import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthService with ChangeNotifier {
  User? _currentUser;
  final List<User> _dummyUsers = []; // Simulate database

  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  Future<void> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network call

    // Check dummy users (replace with Firebase in real app)
    final user = _dummyUsers.firstWhere(
      (u) => u.email == email && u.password == password,
      orElse: () => User(email: '', password: ''),
    );

    if (user.email.isEmpty) {
      throw Exception('Invalid email or password');
    }

    _currentUser = user;
    notifyListeners();
  }

  Future<void> signup(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1)); // Simulate network call

    if (_dummyUsers.any((u) => u.email == email)) {
      throw Exception('Email already exists');
    }

    final newUser = User(email: email, password: password);
    _dummyUsers.add(newUser);
    _currentUser = newUser;
    notifyListeners();
  }

  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
