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
    print('📝 REGISTER PROVIDER: Starting registration process');
    print('📝 REGISTER PROVIDER: Name: $firstName $lastName, Email: $email');

    // Validate inputs
    if (firstName.isEmpty || lastName.isEmpty) {
      print('⚠️ REGISTER PROVIDER: Validation failed - Name is empty');
      _showError(context, 'Please enter your full name');
      return false;
    }

    if (email.isEmpty || !email.contains('@')) {
      print('⚠️ REGISTER PROVIDER: Validation failed - Invalid email');
      _showError(context, 'Please enter a valid email address');
      return false;
    }

    if (password.length < 8) {
      print('⚠️ REGISTER PROVIDER: Validation failed - Password too short');
      _showError(context, 'Password must be at least 8 characters');
      return false;
    }

    print('✅ REGISTER PROVIDER: Validation passed');
    _isLoading = true;
    notifyListeners();

    try {
      print('📝 REGISTER PROVIDER: Calling auth service...');
      final result = await _authService.register(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
      );

      if (result != null) {
        print('✅ REGISTER PROVIDER: Registration successful!');
        _isLoading = false;
        notifyListeners();
        return true;
      }

      print('⚠️ REGISTER PROVIDER: Registration returned null');
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e, stackTrace) {
      print('❌ REGISTER PROVIDER ERROR: Registration failed: $e');
      print('❌ REGISTER PROVIDER ERROR: Stack trace: $stackTrace');
      _isLoading = false;
      notifyListeners();

      if (context.mounted) {
        String errorMessage = 'Registration failed. Please try again.';

        if (e.toString().contains('already exists')) {
          errorMessage = 'An account with this email already exists.';
          print('⚠️ REGISTER PROVIDER: Email already exists');
        } else if (e.toString().contains('network')) {
          errorMessage = 'Network error. Please check your connection.';
          print('⚠️ REGISTER PROVIDER: Network error detected');
        } else if (e.toString().contains('Invalid email')) {
          errorMessage = 'Please enter a valid email address.';
          print('⚠️ REGISTER PROVIDER: Invalid email format');
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
