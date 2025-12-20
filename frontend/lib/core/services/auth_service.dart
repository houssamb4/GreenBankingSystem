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
        refreshToken
        user {
          id
          email
          firstName
          lastName
          ecoScore
          totalCarbonSaved
          monthlyCarbonBudget
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
        refreshToken
        user {
          id
          email
          firstName
          lastName
          ecoScore
          totalCarbonSaved
          monthlyCarbonBudget
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
        ecoScore
        totalCarbonSaved
        monthlyCarbonBudget
        createdAt
        updatedAt
      }
    }
  ''';

  Future<Map<String, dynamic>?> login(String email, String password) async {
    try {
      final result = await _graphQLService.mutate(
        loginMutation,
        variables: {
          'email': email,
          'password': password,
        },
      );

      final loginData = result['data']?['login'];
      print('DEBUG AUTH: Login response data: $loginData'); // Log the raw response

      if (loginData != null) {
        // Save tokens
        print('DEBUG AUTH: Saving tokens...');
        await _tokenStorage.saveToken(loginData['token']);
        await _tokenStorage.saveRefreshToken(loginData['refreshToken']);
        await _tokenStorage.saveUserId(loginData['user']['id']);
        await _tokenStorage.saveUserEmail(loginData['user']['email']);
        await _tokenStorage.saveUserJson(loginData['user']);
        print('DEBUG AUTH: Tokens saved successfully.');
      } else {
        print('DEBUG AUTH: Login data is null!');
      }

      return loginData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> register({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final result = await _graphQLService.mutate(
        registerMutation,
        variables: {
          'email': email,
          'password': password,
          'firstName': firstName,
          'lastName': lastName,
        },
      );

      final registerData = result['data']?['register'];
      if (registerData != null) {
        // Save tokens
        await _tokenStorage.saveToken(registerData['token']);
        await _tokenStorage.saveRefreshToken(registerData['refreshToken']);
        await _tokenStorage.saveUserId(registerData['user']['id']);
        await _tokenStorage.saveUserEmail(registerData['user']['email']);
        await _tokenStorage.saveUserJson(registerData['user']);
      }

      return registerData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      print('DEBUG AUTH: Fetching current user...');
      final token = await _tokenStorage.getToken();
      print('DEBUG AUTH: Token exists: ${token != null}');
      
      final result = await _graphQLService.query(getCurrentUserQuery);
      print('DEBUG AUTH: Query result: $result');
      return result['data']?['getCurrentUser'];
    } catch (e, stackTrace) {
      print('DEBUG AUTH ERROR: $e');
      print('DEBUG AUTH STACK: $stackTrace');
      
      // Fallback to cached user data if available
      print('DEBUG AUTH: Attempting to retrieve cached user data...');
      final cachedUser = await _tokenStorage.getUserJson();
      if (cachedUser != null) {
        print('DEBUG AUTH: Returning cached user data.');
        return cachedUser;
      }
      
      rethrow;
    }
  }

  Future<void> logout() async {
    await _tokenStorage.clearAll();
  }

  Future<bool> isLoggedIn() async {
    return await _tokenStorage.isLoggedIn();
  }
}
