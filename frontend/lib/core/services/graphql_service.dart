import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:greenpay/core/services/token_storage_service.dart';

class GraphQLService {
  static GraphQLService? _instance;
  static GraphQLService get instance => _instance ??= GraphQLService._();

  GraphQLService._();

  static const String _endpoint = String.fromEnvironment(
    'GRAPHQL_ENDPOINT',
    defaultValue: 'http://localhost:8081/graphql',
  );

  final TokenStorageService _tokenStorage = TokenStorageService.instance;

  Future<Map<String, dynamic>> query(String query,
      {Map<String, dynamic>? variables}) async {
    print('🔍 GRAPHQL: Executing QUERY');
    return await _executeRequest(query, variables);
  }

  Future<Map<String, dynamic>> mutate(String mutation,
      {Map<String, dynamic>? variables}) async {
    print('✏️ GRAPHQL: Executing MUTATION');
    return await _executeRequest(mutation, variables);
  }

  Future<Map<String, dynamic>> _executeRequest(
      String query, Map<String, dynamic>? variables) async {
    print('🌐 GRAPHQL: Executing request to $_endpoint');
    try {
      final token = await _tokenStorage.getToken();
      print('🔑 GRAPHQL: Token status: ${token != null ? "PRESENT (${token.substring(0, 20)}...)" : "MISSING"}');

      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };

      if (token != null) {
        print('✅ GRAPHQL: Authorization header added');
      } else {
        print('⚠️ GRAPHQL: No authorization token (anonymous request)');
      }

      final body = json.encode({
        'query': query,
        if (variables != null && variables.isNotEmpty) 'variables': variables,
      });

      print('📤 GRAPHQL: Sending request...');
      if (variables != null && variables.isNotEmpty) {
        print('📤 GRAPHQL: Variables: $variables');
      }

      final response = await http.post(
        Uri.parse(_endpoint),
        headers: headers,
        body: body,
      );

      print('📥 GRAPHQL: Received response with status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;

        if (responseData.containsKey('errors')) {
          final errors = responseData['errors'] as List;
          if (errors.isNotEmpty) {
            final errorMessage = errors[0]['message'];
            print('❌ GRAPHQL ERROR: GraphQL error in response: $errorMessage');
            print('❌ GRAPHQL ERROR: Full errors: $errors');
            throw Exception(errorMessage);
          }
        }

        print('✅ GRAPHQL: Request successful');
        return responseData;
      } else {
        print('❌ GRAPHQL ERROR: HTTP error ${response.statusCode}');
        print('❌ GRAPHQL ERROR: Response body: ${response.body}');
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e, stackTrace) {
      print('❌ GRAPHQL ERROR: Request failed with exception: $e');
      print('❌ GRAPHQL ERROR: Stack trace: $stackTrace');
      print('❌ GRAPHQL ERROR: Endpoint: $_endpoint');
      rethrow;
    }
  }
}
