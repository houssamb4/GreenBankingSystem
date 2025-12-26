import 'package:greenpay/core/services/graphql_service.dart';
import 'package:greenpay/core/services/token_storage_service.dart';

class AuthService {
  static AuthService? _instance;
  static AuthService get instance => _instance ??= AuthService._();

  AuthService._();

  final GraphQLService _graphQLService = GraphQLService.instance;
  final TokenStorageService _tokenStorage = TokenStorageService.instance;

  // Login mutation
  static const String loginMutation = r'''
    mutation Login($email: String!, $password: String!) {
      login(input: { email: $email, password: $password }) {
        token
        user {
          id
          email
          firstName
          lastName
          fullName
          phoneNumber
          createdAt
          updatedAt
        }
      }
    }
  ''';

  // Register mutation
  static const String registerMutation = r'''
    mutation Register($email: String!, $password: String!, $firstName: String!, $lastName: String!) {
      register(input: {
        email: $email,
        password: $password,
        firstName: $firstName,
        lastName: $lastName
      }) {
        token
        user {
          id
          email
          firstName
          lastName
          fullName
          phoneNumber
          createdAt
          updatedAt
        }
      }
    }
  ''';

  // Get current user query
  static const String getCurrentUserQuery = r'''
    query GetCurrentUser {
      getCurrentUser {
        id
        email
        firstName
        lastName
        fullName
        phoneNumber
        createdAt
        updatedAt
      }
    }
  ''';

  Future<Map<String, dynamic>?> login(String email, String password) async {
    print('🔐 AUTH: Starting login for email: $email');
    try {
      print('🔐 AUTH: Sending login mutation to GraphQL...');
      final result = await _graphQLService.mutate(
        loginMutation,
        variables: {
          'email': email,
          'password': password,
        },
      );

      print('🔐 AUTH: Received GraphQL response');
      final loginData = result['data']?['login'];

      if (loginData != null) {
        print('✅ AUTH: Login successful for user: ${loginData['user']['email']}');
        print('🔐 AUTH: User ID: ${loginData['user']['id']}');

        // Save tokens
        print('💾 AUTH: Saving authentication data...');
        await _tokenStorage.saveToken(loginData['token']);
        await _tokenStorage.saveUserId(loginData['user']['id']);
        await _tokenStorage.saveUserEmail(loginData['user']['email']);
        await _tokenStorage.saveUserJson(loginData['user']);
        print('✅ AUTH: Authentication data saved successfully');
      } else {
        print('❌ AUTH ERROR: Login data is null in response');
        print('❌ AUTH ERROR: Full response: $result');
      }

      return loginData;
    } catch (e, stackTrace) {
      print('❌ AUTH ERROR: Login failed with exception: $e');
      print('❌ AUTH ERROR: Stack trace: $stackTrace');
      print('❌ AUTH ERROR: Email attempted: $email');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    print('📝 AUTH: Starting registration for: $firstName $lastName ($email)');
    try {
      print('📝 AUTH: Sending registration mutation to GraphQL...');
      final result = await _graphQLService.mutate(
        registerMutation,
        variables: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
        },
      );

      print('📝 AUTH: Received GraphQL response');
      final registerData = result['data']?['register'];

      if (registerData != null) {
        print('✅ AUTH: Registration successful!');
        print('📝 AUTH: User created: ${registerData['user']['fullName']}');
        print('📝 AUTH: User ID: ${registerData['user']['id']}');

        // Save tokens
        print('💾 AUTH: Saving authentication data...');
        await _tokenStorage.saveToken(registerData['token']);
        await _tokenStorage.saveUserId(registerData['user']['id']);
        await _tokenStorage.saveUserEmail(registerData['user']['email']);
        await _tokenStorage.saveUserJson(registerData['user']);
        print('✅ AUTH: Authentication data saved successfully');
      } else {
        print('❌ AUTH ERROR: Registration data is null in response');
        print('❌ AUTH ERROR: Full response: $result');
      }

      return registerData;
    } catch (e, stackTrace) {
      print('❌ AUTH ERROR: Registration failed with exception: $e');
      print('❌ AUTH ERROR: Stack trace: $stackTrace');
      print('❌ AUTH ERROR: Email attempted: $email');
      print('❌ AUTH ERROR: Name: $firstName $lastName');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    print('👤 AUTH: Fetching current user data...');
    try {
      final token = await _tokenStorage.getToken();
      print('👤 AUTH: Token exists: ${token != null}');

      if (token == null) {
        print('⚠️ AUTH WARNING: No token found, user not authenticated');
        return null;
      }

      print('👤 AUTH: Sending getCurrentUser query to GraphQL...');
      final result = await _graphQLService.query(getCurrentUserQuery);
      print('👤 AUTH: Received GraphQL response');

      final userData = result['data']?['getCurrentUser'];
      if (userData != null) {
        print('✅ AUTH: User data retrieved: ${userData['email']}');
        return userData;
      } else {
        print('⚠️ AUTH WARNING: No user data in response');
        return null;
      }
    } catch (e, stackTrace) {
      print('❌ AUTH ERROR: Failed to fetch current user: $e');
      print('❌ AUTH ERROR: Stack trace: $stackTrace');

      // Fallback to cached user data if available
      print('💾 AUTH: Attempting to retrieve cached user data...');
      try {
        final cachedUser = await _tokenStorage.getUserJson();
        if (cachedUser != null) {
          print('✅ AUTH: Returning cached user data for: ${cachedUser['email']}');
          return cachedUser;
        } else {
          print('⚠️ AUTH WARNING: No cached user data available');
        }
      } catch (cacheError) {
        print('❌ AUTH ERROR: Failed to retrieve cached data: $cacheError');
      }

      rethrow;
    }
  }

  Future<void> logout() async {
    print('🚪 AUTH: Logging out user...');
    try {
      await _tokenStorage.clearAll();
      print('✅ AUTH: User logged out successfully, all tokens cleared');
    } catch (e, stackTrace) {
      print('❌ AUTH ERROR: Logout failed: $e');
      print('❌ AUTH ERROR: Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<bool> isLoggedIn() async {
    try {
      final loggedIn = await _tokenStorage.isLoggedIn();
      print('🔍 AUTH: User logged in status: $loggedIn');
      return loggedIn;
    } catch (e, stackTrace) {
      print('❌ AUTH ERROR: Failed to check login status: $e');
      print('❌ AUTH ERROR: Stack trace: $stackTrace');
      return false;
    }
  }
}
