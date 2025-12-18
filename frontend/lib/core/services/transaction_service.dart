import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:greenpay/core/models/transaction.dart';
import 'package:greenpay/core/services/graphql_service.dart';

class TransactionService {
  static TransactionService? _instance;
  static TransactionService get instance =>
      _instance ??= TransactionService._();

  TransactionService._();

  final GraphQLService _graphQLService = GraphQLService.instance;

  // Create transaction mutation
  static const String createTransactionMutation = r'''
    mutation CreateTransaction($amount: Float!, $category: String!, $merchant: String!, $description: String) {
      createTransaction(input: { 
        amount: $amount, 
        category: $category, 
        merchant: $merchant,
        description: $description
      }) {
        id
        amount
        currency
        category
        merchant
        description
        carbonFootprint
        transactionDate
        createdAt
      }
    }
  ''';

  // Get user transactions query
  static const String getUserTransactionsQuery = r'''
    query GetTransactions($userId: ID!) {
      getUserTransactions(userId: $userId) {
        id
        amount
        currency
        category
        merchant
        description
        carbonFootprint
        transactionDate
        createdAt
      }
    }
  ''';

  // Get carbon stats query
  static const String getCarbonStatsQuery = r'''
    query GetCarbonStats($userId: ID!) {
      getCarbonStats(userId: $userId) {
        userId
        totalCarbon
        monthlyCarbon
        carbonBudget
        carbonPercentage
        ecoScore
      }
    }
  ''';

  // Get category breakdown query
  static const String getCategoryBreakdownQuery = r'''
    query GetCategoryBreakdown($userId: ID!) {
      getCategoryBreakdown(userId: $userId) {
        category
        totalCarbon
        totalAmount
        transactionCount
        percentage
      }
    }
  ''';

  // Update carbon budget mutation
  static const String updateCarbonBudgetMutation = r'''
    mutation UpdateBudget($budget: Float!) {
      updateCarbonBudget(budget: $budget) {
        id
        monthlyCarbonBudget
      }
    }
  ''';

  Future<Transaction?> createTransaction({
    required double amount,
    required String category,
    required String merchant,
    String? description,
  }) async {
    try {
      final GraphQLClient client = _graphQLService.getClient();

      final QueryResult result = await client.mutate(
        MutationOptions(
          document: gql(createTransactionMutation),
          variables: {
            'amount': amount,
            'category': category,
            'merchant': merchant,
            if (description != null) 'description': description,
          },
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final transactionData = result.data?['createTransaction'];
      if (transactionData != null) {
        return Transaction.fromJson(transactionData);
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Transaction>> getUserTransactions(String userId) async {
    try {
      final GraphQLClient client = _graphQLService.getClient();

      final QueryResult result = await client.query(
        QueryOptions(
          document: gql(getUserTransactionsQuery),
          variables: {'userId': userId},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final transactionsData = result.data?['getUserTransactions'] as List?;
      if (transactionsData != null) {
        return transactionsData
            .map((json) => Transaction.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<CarbonStats?> getCarbonStats(String userId) async {
    try {
      final GraphQLClient client = _graphQLService.getClient();

      final QueryResult result = await client.query(
        QueryOptions(
          document: gql(getCarbonStatsQuery),
          variables: {'userId': userId},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final statsData = result.data?['getCarbonStats'];
      if (statsData != null) {
        return CarbonStats.fromJson(statsData);
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CategoryBreakdown>> getCategoryBreakdown(String userId) async {
    try {
      final GraphQLClient client = _graphQLService.getClient();

      final QueryResult result = await client.query(
        QueryOptions(
          document: gql(getCategoryBreakdownQuery),
          variables: {'userId': userId},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      final breakdownData = result.data?['getCategoryBreakdown'] as List?;
      if (breakdownData != null) {
        return breakdownData
            .map((json) => CategoryBreakdown.fromJson(json))
            .toList();
      }

      return [];
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateCarbonBudget(double budget) async {
    try {
      final GraphQLClient client = _graphQLService.getClient();

      final QueryResult result = await client.mutate(
        MutationOptions(
          document: gql(updateCarbonBudgetMutation),
          variables: {'budget': budget},
        ),
      );

      if (result.hasException) {
        throw Exception(result.exception.toString());
      }

      return result.data?['updateCarbonBudget'];
    } catch (e) {
      rethrow;
    }
  }
}
