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
    mutation CreateTransaction($amount: BigDecimal!, $category: String!, $merchant: String!, $description: String) {
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
    query GetTransactions($userId: UUID!) {
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
    query GetCarbonStats($userId: UUID!) {
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
    query GetCategoryBreakdown($userId: UUID!) {
      getCategoryBreakdown(userId: $userId) {
        category
        totalCarbon
        totalAmount
        transactionCount
        percentage
      }
    }
  ''';

  // Get monthly historical carbon query
  static const String getMonthlyHistoricalCarbonQuery = r'''
    query GetMonthlyHistoricalCarbon($userId: UUID!) {
      getMonthlyHistoricalCarbon(userId: $userId)
    }
  ''';

  // Update carbon budget mutation
  static const String updateCarbonBudgetMutation = r'''
    mutation UpdateBudget($budget: BigDecimal!) {
      updateCarbonBudget(budget: $budget) {
        id
        monthlyCarbonBudget
      }
    }
  ''';

  // Update transaction mutation
  static const String updateTransactionMutation = r'''
    mutation UpdateTransaction($id: UUID!, $amount: BigDecimal!, $category: String!, $merchant: String!, $description: String) {
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
        updatedAt
      }
    }
  ''';

  // Delete transaction mutation
  static const String deleteTransactionMutation = r'''
    mutation DeleteTransaction($id: UUID!) {
      deleteTransaction(id: $id)
    }
  ''';

  // Get single transaction query
  static const String getTransactionQuery = r'''
    query GetTransaction($id: UUID!) {
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
    required double amount,
    required String category,
    required String merchant,
    String? description,
  }) async {
    try {
      final result = await _graphQLService.mutate(
        updateTransactionMutation,
        variables: {
          'id': id,
          'amount': amount,
          'category': category,
          'merchant': merchant,
          if (description != null && description.isNotEmpty) 'description': description,
        },
      );

      final transactionData = result['data']?['updateTransaction'];
      if (transactionData != null) {
        return Transaction.fromJson(transactionData);
      }

      return null;
    } catch (e) {
      print('DEBUG: Update transaction error: $e');
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

  Future<List<double>> getMonthlyHistoricalCarbon(String userId) async {
    try {
      final result = await _graphQLService.query(
        getMonthlyHistoricalCarbonQuery,
        variables: {'userId': userId},
      );

      final monthlyData =
          result['data']?['getMonthlyHistoricalCarbon'] as List?;
      if (monthlyData != null) {
        return monthlyData.map((value) => (value as num).toDouble()).toList();
      }

      return List.filled(12, 0.0);
    } catch (e) {
      rethrow;
    }
  }
}
