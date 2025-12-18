import 'package:graphql_flutter/graphql_flutter.dart';
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
      final GraphQLClient client = _graphQLService.getClient();

      final QueryResult result = await client.mutate(
        MutationOptions(
          document: gql(loginMutation),
          variables: {
            'email': email,
            'password': password,
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final loginData = result.data?['login'];
      if (loginData != null) {
        // Save tokens
        await _tokenStorage.saveToken(loginData['token']);
        await _tokenStorage.saveRefreshToken(loginData['refreshToken']);
        await _tokenStorage.saveUserId(loginData['user']['id']);
        await _tokenStorage.saveUserEmail(loginData['user']['email']);
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
      final GraphQLClient client = _graphQLService.getClient();

      final QueryResult result = await client.mutate(
        MutationOptions(
          document: gql(registerMutation),
          variables: {
            'email': email,
            'password': password,
            'firstName': firstName,
            'lastName': lastName,
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final registerData = result.data?['register'];
      if (registerData != null) {
        // Save tokens
        await _tokenStorage.saveToken(registerData['token']);
        await _tokenStorage.saveRefreshToken(registerData['refreshToken']);
        await _tokenStorage.saveUserId(registerData['user']['id']);
        await _tokenStorage.saveUserEmail(registerData['user']['email']);
      }

      return registerData;
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> getCurrentUser() async {
    try {
      final GraphQLClient client = _graphQLService.getClient();

      final QueryResult result = await client.query(
        QueryOptions(
          document: gql(getCurrentUserQuery),
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      return result.data?['getCurrentUser'];
    } catch (e) {
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
