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
    try {
      final jsonString = jsonEncode(userJson);
      await _storage.write(key: _userJsonKey, value: jsonString);
      print('DEBUG STORAGE: User JSON saved.');
    } catch (e) {
      print('DEBUG STORAGE ERROR saving user JSON: $e');
    }
  }

  Future<Map<String, dynamic>?> getUserJson() async {
    try {
      final jsonString = await _storage.read(key: _userJsonKey);
      if (jsonString != null) {
        print('DEBUG STORAGE: User JSON retrieved.');
        return jsonDecode(jsonString) as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('DEBUG STORAGE ERROR getting user JSON: $e');
      return null;
    }
  }

  Future<void> saveToken(String token) async {
    print('DEBUG STORAGE: Saving token: ${token.substring(0, 10)}...');
    await _storage.write(key: _tokenKey, value: token);
  }

  Future<String?> getToken() async {
    final token = await _storage.read(key: _tokenKey);
    print('DEBUG STORAGE: Retrieved token: ${token != null ? "${token.substring(0, 10)}..." : "null"}');
    return token;
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  Future<void> saveUserId(String userId) async {
    await _storage.write(key: _userIdKey, value: userId);
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: _userIdKey);
  }

  Future<void> saveUserEmail(String email) async {
    await _storage.write(key: _userEmailKey, value: email);
  }

  Future<String?> getUserEmail() async {
    return await _storage.read(key: _userEmailKey);
  }

  Future<void> clearAll() async {
    await _storage.deleteAll();
  }

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }
}
