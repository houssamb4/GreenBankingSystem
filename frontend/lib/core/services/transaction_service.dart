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

  // Update transaction mutation
  static const String updateTransactionMutation = r'''
    mutation UpdateTransaction($id: ID!, $amount: Float, $category: String, $merchant: String, $description: String) {
      updateTransaction(
        id: $id
        input: {
          amount: $amount
          category: $category
          merchant: $merchant
          description: $description
        }
      ) {
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

  // Delete transaction mutation
  static const String deleteTransactionMutation = r'''
    mutation DeleteTransaction($id: ID!) {
      deleteTransaction(id: $id)
    }
  ''';

  // Get single transaction query
  static const String getTransactionQuery = r'''
    query GetTransaction($id: ID!) {
      getTransaction(id: $id) {
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

  Future<Transaction?> createTransaction({
    required double amount,
    required String category,
    required String merchant,
    String? description,
  }) async {
    try {
      final result = await _graphQLService.mutate(
        createTransactionMutation,
        variables: {
          'amount': amount,
          'category': category,
          'merchant': merchant,
          if (description != null) 'description': description,
        },
      );

      final transactionData = result['data']?['createTransaction'];
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
      final result = await _graphQLService.query(
        getUserTransactionsQuery,
        variables: {'userId': userId},
      );

      final transactionsData = result['data']?['getUserTransactions'] as List?;
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
      final result = await _graphQLService.query(
        getCarbonStatsQuery,
        variables: {'userId': userId},
      );

      final statsData = result['data']?['getCarbonStats'];
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
      final result = await _graphQLService.query(
        getCategoryBreakdownQuery,
        variables: {'userId': userId},
      );

      final breakdownData = result['data']?['getCategoryBreakdown'] as List?;
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
      final result = await _graphQLService.mutate(
        updateCarbonBudgetMutation,
        variables: {'budget': budget},
      );

      return result['data']?['updateCarbonBudget'];
    } catch (e) {
      rethrow;
    }
  }

  Future<Transaction?> getTransaction(String id) async {
    try {
      final result = await _graphQLService.query(
        getTransactionQuery,
        variables: {'id': id},
      );

      final transactionData = result['data']?['getTransaction'];
      if (transactionData != null) {
        return Transaction.fromJson(transactionData);
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<Transaction?> updateTransaction({
    required String id,
    double? amount,
    String? category,
    String? merchant,
    String? description,
  }) async {
    try {
      final variables = <String, dynamic>{'id': id};
      if (amount != null) variables['amount'] = amount;
      if (category != null) variables['category'] = category;
      if (merchant != null) variables['merchant'] = merchant;
      if (description != null) variables['description'] = description;

      final result = await _graphQLService.mutate(
        updateTransactionMutation,
        variables: variables,
      );

      final transactionData = result['data']?['updateTransaction'];
      if (transactionData != null) {
        return Transaction.fromJson(transactionData);
      }

      return null;
    } catch (e) {
      rethrow;
    }
  }

  Future<bool> deleteTransaction(String id) async {
    try {
      final result = await _graphQLService.mutate(
        deleteTransactionMutation,
        variables: {'id': id},
      );

      return result['data']?['deleteTransaction'] == true;
    } catch (e) {
      rethrow;
    }
  }
}
