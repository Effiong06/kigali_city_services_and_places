import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Stream<User?> get authStateChanges => _authService.user;

  // Method to handle registration
  Future<String?> register(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    String? result = await _authService.signUp(email, password);
    
    _isLoading = false;
    notifyListeners();
    return result;
  }

  // Method to handle login
  Future<String?> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    
    String? result = await _authService.logIn(email, password);
    
    _isLoading = false;
    notifyListeners();
    return result;
  }

  Future<void> signOut() async {
    await _authService.signOut();
    notifyListeners();
  }
}