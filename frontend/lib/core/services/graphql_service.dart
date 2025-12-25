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
    return await _executeRequest(query, variables);
  }

  Future<Map<String, dynamic>> mutate(String mutation,
      {Map<String, dynamic>? variables}) async {
    return await _executeRequest(mutation, variables);
  }

  Future<Map<String, dynamic>> _executeRequest(
      String query, Map<String, dynamic>? variables) async {
    try {
      final token = await _tokenStorage.getToken();
      print('DEBUG GRAPHQL: Token for request: ${token != null ? "PRESENT" : "MISSING"}');

      final headers = {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      };
      if (token != null) {
         print('DEBUG GRAPHQL: Authorization header set.');
      }

      final body = json.encode({
        'query': query,
        if (variables != null && variables.isNotEmpty) 'variables': variables,
      });

      final response = await http.post(
        Uri.parse(_endpoint),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body) as Map<String, dynamic>;

        if (responseData.containsKey('errors')) {
          final errors = responseData['errors'] as List;
          if (errors.isNotEmpty) {
            throw Exception(errors[0]['message']);
          }
        }

        return responseData;
      } else {
        throw Exception('HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
