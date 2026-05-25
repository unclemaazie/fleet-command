import 'package:flutter/foundation.dart';
import '../vendor/provider.dart';
import '../models/user_model.dart';

class AuthProvider extends ChangeNotifier {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;
  bool get isManager => _currentUser?.role == 'manager';
  bool get isDriver => _currentUser?.role == 'driver';

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 1));

    if (email == 'manager@fikisfleetcommand.io' && password == 'Fleet@2024') {
      _currentUser = User(
        id: 'manager_001',
        email: 'manager@fikisfleetcommand.io',
        name: 'Fleet Manager',
        role: 'manager',
        createdAt: DateTime.now(),
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } else if (email == 'driver@fikisfleetcommand.io' && password == 'Driver@2024') {
      _currentUser = User(
        id: 'driver_001',
        email: 'driver@fikisfleetcommand.io',
        name: 'John Driver',
        role: 'driver',
        createdAt: DateTime.now(),
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } else {
      _error = 'Invalid credentials';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void logout() {
    _currentUser = null;
    _error = null;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
