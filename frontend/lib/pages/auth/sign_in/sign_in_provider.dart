import 'package:flareline_uikit/core/mvvm/base_viewmodel.dart';
import 'package:flareline_uikit/utils/snackbar_util.dart';
import 'package:flutter/material.dart';
import 'package:greenpay/core/services/auth_service.dart';

class SignInProvider extends BaseViewModel {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  final AuthService _authService = AuthService.instance;
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  SignInProvider(BuildContext ctx) : super(ctx) {
    emailController = TextEditingController();
    passwordController = TextEditingController();
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    SnackBarUtil.showSnack(context, 'Sign In With Google - Coming Soon');
  }

  Future<void> signInWithGithub(BuildContext context) async {
    SnackBarUtil.showSnack(context, 'Sign In With Github - Coming Soon');
  }

  Future<void> signIn(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    // Validate inputs
    if (email.isEmpty || !email.contains('@')) {
      SnackBarUtil.showSnack(context, 'Please enter a valid email address');
      return;
    }

    if (password.isEmpty || password.length < 6) {
      SnackBarUtil.showSnack(context, 'Password must be at least 6 characters');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final result = await _authService.login(email, password);

      if (result != null) {
        // Login successful
        if (context.mounted) {
          SnackBarUtil.showSnack(
            context,
            'Welcome back, ${result['user']['firstName']}!',
          );
          Navigator.of(context).pushReplacementNamed('/');
        }
      }
    } catch (e) {
      if (context.mounted) {
        String errorMessage = 'Login failed. Please check your credentials.';

        // Parse error message
        if (e.toString().contains('User not found')) {
          errorMessage = 'No account found with this email.';
        } else if (e.toString().contains('Invalid password')) {
          errorMessage = 'Incorrect password.';
        } else if (e.toString().contains('network')) {
          errorMessage = 'Network error. Please check your connection.';
        }

        SnackBarUtil.showSnack(context, errorMessage);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
