import 'package:flutter/material.dart';
import 'package:greenpay/core/services/auth_service.dart';

class RegisterProvider extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<bool> register({
    required BuildContext context,
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    // Validate inputs
    if (firstName.isEmpty || lastName.isEmpty) {
      _showError(context, 'Please enter your full name');
      return false;
    }

    if (email.isEmpty || !email.contains('@')) {
      _showError(context, 'Please enter a valid email address');
      return false;
    }

    if (password.length < 8) {
      _showError(context, 'Password must be at least 8 characters');
      return false;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      if (result != null) {
        _isLoading = false;
        notifyListeners();
        return true;
      }

      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      if (context.mounted) {
        String errorMessage = 'Registration failed. Please try again.';

        if (e.toString().contains('already exists')) {
          errorMessage = 'An account with this email already exists.';
        } else if (e.toString().contains('network')) {
          errorMessage = 'Network error. Please check your connection.';
        } else if (e.toString().contains('Invalid email')) {
          errorMessage = 'Please enter a valid email address.';
        }

        _showError(context, errorMessage);
      }
      return false;
    }
  }

  void _showError(BuildContext context, String message) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
