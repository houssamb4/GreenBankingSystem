import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';

class TokenStorageService {
  static TokenStorageService? _instance;
  static TokenStorageService get instance =>
      _instance ??= TokenStorageService._();

  TokenStorageService._();

  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';
  static const String _userEmailKey = 'user_email';
  static const String _userJsonKey = 'user_json';

  Future<void> saveUserJson(Map<String, dynamic> userJson) async {
    print('💾 STORAGE: Saving user JSON for: ${userJson['email']}');
    try {
      final jsonString = jsonEncode(userJson);
      await _storage.write(key: _userJsonKey, value: jsonString);
      print('✅ STORAGE: User JSON saved successfully');
    } catch (e, stackTrace) {
      print('❌ STORAGE ERROR: Failed to save user JSON: $e');
      print('❌ STORAGE ERROR: Stack trace: $stackTrace');
    }
  }

  Future<Map<String, dynamic>?> getUserJson() async {
    print('💾 STORAGE: Retrieving user JSON...');
    try {
      final jsonString = await _storage.read(key: _userJsonKey);
      if (jsonString != null) {
        final userData = jsonDecode(jsonString) as Map<String, dynamic>;
        print('✅ STORAGE: User JSON retrieved for: ${userData['email']}');
        return userData;
      }
      print('⚠️ STORAGE: No user JSON found');
      return null;
    } catch (e, stackTrace) {
      print('❌ STORAGE ERROR: Failed to get user JSON: $e');
      print('❌ STORAGE ERROR: Stack trace: $stackTrace');
      return null;
    }
  }

  Future<void> saveToken(String token) async {
    print('💾 STORAGE: Saving auth token (${token.substring(0, 20)}...)');
    try {
      await _storage.write(key: _tokenKey, value: token);
      print('✅ STORAGE: Token saved successfully');
    } catch (e, stackTrace) {
      print('❌ STORAGE ERROR: Failed to save token: $e');
      print('❌ STORAGE ERROR: Stack trace: $stackTrace');
    }
  }

  Future<String?> getToken() async {
    try {
      final token = await _storage.read(key: _tokenKey);
      if (token != null) {
        print('✅ STORAGE: Token retrieved (${token.substring(0, 20)}...)');
      } else {
        print('⚠️ STORAGE: No token found');
      }
      return token;
    } catch (e, stackTrace) {
      print('❌ STORAGE ERROR: Failed to get token: $e');
      print('❌ STORAGE ERROR: Stack trace: $stackTrace');
      return null;
    }
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    print('💾 STORAGE: Saving refresh token');
    try {
      await _storage.write(key: _refreshTokenKey, value: refreshToken);
      print('✅ STORAGE: Refresh token saved');
    } catch (e, stackTrace) {
      print('❌ STORAGE ERROR: Failed to save refresh token: $e');
      print('❌ STORAGE ERROR: Stack trace: $stackTrace');
    }
  }

  Future<String?> getRefreshToken() async {
    try {
      final token = await _storage.read(key: _refreshTokenKey);
      print('💾 STORAGE: Refresh token ${token != null ? "found" : "not found"}');
      return token;
    } catch (e, stackTrace) {
      print('❌ STORAGE ERROR: Failed to get refresh token: $e');
      print('❌ STORAGE ERROR: Stack trace: $stackTrace');
      return null;
    }
  }

  Future<void> saveUserId(String userId) async {
    print('💾 STORAGE: Saving user ID: $userId');
    try {
      await _storage.write(key: _userIdKey, value: userId);
      print('✅ STORAGE: User ID saved');
    } catch (e, stackTrace) {
      print('❌ STORAGE ERROR: Failed to save user ID: $e');
      print('❌ STORAGE ERROR: Stack trace: $stackTrace');
    }
  }

  Future<String?> getUserId() async {
    try {
      final userId = await _storage.read(key: _userIdKey);
      print('💾 STORAGE: User ID ${userId != null ? "retrieved: $userId" : "not found"}');
      return userId;
    } catch (e, stackTrace) {
      print('❌ STORAGE ERROR: Failed to get user ID: $e');
      print('❌ STORAGE ERROR: Stack trace: $stackTrace');
      return null;
    }
  }

  Future<void> saveUserEmail(String email) async {
    print('💾 STORAGE: Saving user email: $email');
    try {
      await _storage.write(key: _userEmailKey, value: email);
      print('✅ STORAGE: User email saved');
    } catch (e, stackTrace) {
      print('❌ STORAGE ERROR: Failed to save user email: $e');
      print('❌ STORAGE ERROR: Stack trace: $stackTrace');
    }
  }

  Future<String?> getUserEmail() async {
    try {
      final email = await _storage.read(key: _userEmailKey);
      print('💾 STORAGE: User email ${email != null ? "retrieved: $email" : "not found"}');
      return email;
    } catch (e, stackTrace) {
      print('❌ STORAGE ERROR: Failed to get user email: $e');
      print('❌ STORAGE ERROR: Stack trace: $stackTrace');
      return null;
    }
  }

  Future<void> clearAll() async {
    print('🗑️ STORAGE: Clearing all stored data...');
    try {
      await _storage.deleteAll();
      print('✅ STORAGE: All data cleared successfully');
    } catch (e, stackTrace) {
      print('❌ STORAGE ERROR: Failed to clear storage: $e');
      print('❌ STORAGE ERROR: Stack trace: $stackTrace');
    }
  }

  Future<bool> isLoggedIn() async {
    print('🔍 STORAGE: Checking login status...');
    try {
      final token = await getToken();
      final loggedIn = token != null && token.isNotEmpty;
      print('🔍 STORAGE: User is ${loggedIn ? "logged in" : "not logged in"}');
      return loggedIn;
    } catch (e, stackTrace) {
      print('❌ STORAGE ERROR: Failed to check login status: $e');
      print('❌ STORAGE ERROR: Stack trace: $stackTrace');
      return false;
    }
  }
}
