import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user_model.dart';

class AuthService extends ChangeNotifier {
  User? _user;
  String? _token;
  String? _refreshToken;
  bool _isAuthenticated = false;

  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _isAuthenticated;

  AuthService() {
    _loadAuthData();
  }

  Future<void> _loadAuthData() async {
    try {
      _token = await _secureStorage.read(key: 'token');
      _refreshToken = await _secureStorage.read(key: 'refreshToken');

      if (_token != null) {
        final prefs = await SharedPreferences.getInstance();
        final userId = prefs.getString('userId');
        final email = prefs.getString('email');
        final firstName = prefs.getString('firstName');
        final lastName = prefs.getString('lastName');
        final ecoScore = prefs.getInt('ecoScore') ?? 100;
        final totalCarbonSaved = prefs.getDouble('totalCarbonSaved') ?? 0.0;
        final monthlyCarbonBudget = prefs.getDouble('monthlyCarbonBudget') ?? 100.0;

        if (userId != null && email != null) {
          _user = User(
            id: userId,
            email: email,
            firstName: firstName,
            lastName: lastName,
            ecoScore: ecoScore,
            totalCarbonSaved: totalCarbonSaved,
            monthlyCarbonBudget: monthlyCarbonBudget,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          );
          _isAuthenticated = true;
        }
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading auth data: $e');
    }
  }

  Future<void> login(AuthResponse authResponse) async {
    try {
      _token = authResponse.token;
      _refreshToken = authResponse.refreshToken;
      _user = authResponse.user;
      _isAuthenticated = true;

      await _secureStorage.write(key: 'token', value: _token);
      await _secureStorage.write(key: 'refreshToken', value: _refreshToken);

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('userId', _user!.id);
      await prefs.setString('email', _user!.email);
      if (_user!.firstName != null) {
        await prefs.setString('firstName', _user!.firstName!);
      }
      if (_user!.lastName != null) {
        await prefs.setString('lastName', _user!.lastName!);
      }
      await prefs.setInt('ecoScore', _user!.ecoScore);
      await prefs.setDouble('totalCarbonSaved', _user!.totalCarbonSaved);
      await prefs.setDouble('monthlyCarbonBudget', _user!.monthlyCarbonBudget);

      notifyListeners();
    } catch (e) {
      debugPrint('Error during login: $e');
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _secureStorage.delete(key: 'token');
      await _secureStorage.delete(key: 'refreshToken');

      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      _token = null;
      _refreshToken = null;
      _user = null;
      _isAuthenticated = false;

      notifyListeners();
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }

  void updateUser(User user) {
    _user = user;
    notifyListeners();
  }
}
