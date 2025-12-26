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
        merchantName
        description
        carbonFootprint
        date
        createdAt
        updatedAt
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
        merchantName
        description
        carbonFootprint
        date
        createdAt
        updatedAt
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
        merchantName
        description
        carbonFootprint
        date
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
        merchantName
        description
        carbonFootprint
        date
        createdAt
        updatedAt
      }
    }
  ''';

  Future<Transaction?> createTransaction({
    required double amount,
    required String category,
    required String merchant,
    String? description,
  }) async {
    print('💳 TRANSACTION: Creating transaction...');
    print('💳 TRANSACTION: Amount: €$amount, Category: $category, Merchant: $merchant');
    try {
      print('💳 TRANSACTION: Sending createTransaction mutation...');
      final result = await _graphQLService.mutate(
        createTransactionMutation,
        variables: {
          'amount': amount,
          'category': category,
          'merchant': merchant,
          if (description != null) 'description': description,
        },
      );

      print('💳 TRANSACTION: Received GraphQL response');
      final transactionData = result['data']?['createTransaction'];
      if (transactionData != null) {
        print('✅ TRANSACTION: Transaction created successfully');
        print('✅ TRANSACTION: ID: ${transactionData['id']}, Carbon: ${transactionData['carbonFootprint']} g CO2e');
        return Transaction.fromJson(transactionData);
      } else {
        print('⚠️ TRANSACTION WARNING: Transaction data is null in response');
        print('⚠️ TRANSACTION WARNING: Full response: $result');
      }

      return null;
    } catch (e, stackTrace) {
      print('❌ TRANSACTION ERROR: Failed to create transaction: $e');
      print('❌ TRANSACTION ERROR: Stack trace: $stackTrace');
      print('❌ TRANSACTION ERROR: Amount: €$amount, Category: $category, Merchant: $merchant');
      rethrow;
    }
  }

  Future<List<Transaction>> getUserTransactions(String userId) async {
    print('📋 TRANSACTION: Fetching transactions for user: $userId');
    try {
      print('📋 TRANSACTION: Sending getUserTransactions query...');
      final result = await _graphQLService.query(
        getUserTransactionsQuery,
        variables: {'userId': userId},
      );

      print('📋 TRANSACTION: Received GraphQL response');
      final transactionsData = result['data']?['getUserTransactions'] as List?;
      if (transactionsData != null) {
        final transactions = transactionsData
            .map((json) => Transaction.fromJson(json))
            .toList();
        print('✅ TRANSACTION: Retrieved ${transactions.length} transactions');
        return transactions;
      } else {
        print('⚠️ TRANSACTION WARNING: No transactions data in response');
      }

      return [];
    } catch (e, stackTrace) {
      print('❌ TRANSACTION ERROR: Failed to fetch transactions: $e');
      print('❌ TRANSACTION ERROR: Stack trace: $stackTrace');
      print('❌ TRANSACTION ERROR: User ID: $userId');
      rethrow;
    }
  }

  Future<CarbonStats?> getCarbonStats(String userId) async {
    print('📊 TRANSACTION: Fetching carbon stats for user: $userId');
    try {
      print('📊 TRANSACTION: Sending getCarbonStats query...');
      final result = await _graphQLService.query(
        getCarbonStatsQuery,
        variables: {'userId': userId},
      );

      print('📊 TRANSACTION: Received GraphQL response');
      final statsData = result['data']?['getCarbonStats'];
      if (statsData != null) {
        print('✅ TRANSACTION: Carbon stats retrieved');
        print('✅ TRANSACTION: Total: ${statsData['totalCarbon']} g, Monthly: ${statsData['monthlyCarbon']} g, Budget: ${statsData['carbonBudget']} g');
        return CarbonStats.fromJson(statsData);
      } else {
        print('⚠️ TRANSACTION WARNING: No carbon stats data in response');
      }

      return null;
    } catch (e, stackTrace) {
      print('❌ TRANSACTION ERROR: Failed to fetch carbon stats: $e');
      print('❌ TRANSACTION ERROR: Stack trace: $stackTrace');
      print('❌ TRANSACTION ERROR: User ID: $userId');
      rethrow;
    }
  }

  Future<List<CategoryBreakdown>> getCategoryBreakdown(String userId) async {
    print('🎯 TRANSACTION: Fetching category breakdown for user: $userId');
    try {
      print('🎯 TRANSACTION: Sending getCategoryBreakdown query...');
      final result = await _graphQLService.query(
        getCategoryBreakdownQuery,
        variables: {'userId': userId},
      );

      print('🎯 TRANSACTION: Received GraphQL response');
      final breakdownData = result['data']?['getCategoryBreakdown'] as List?;
      if (breakdownData != null) {
        final breakdown = breakdownData
            .map((json) => CategoryBreakdown.fromJson(json))
            .toList();
        print('✅ TRANSACTION: Retrieved ${breakdown.length} category breakdowns');
        return breakdown;
      } else {
        print('⚠️ TRANSACTION WARNING: No category breakdown data in response');
      }

      return [];
    } catch (e, stackTrace) {
      print('❌ TRANSACTION ERROR: Failed to fetch category breakdown: $e');
      print('❌ TRANSACTION ERROR: Stack trace: $stackTrace');
      print('❌ TRANSACTION ERROR: User ID: $userId');
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> updateCarbonBudget(double budget) async {
    print('⚙️ TRANSACTION: Updating carbon budget to: $budget g CO2e');
    try {
      print('⚙️ TRANSACTION: Sending updateCarbonBudget mutation...');
      final result = await _graphQLService.mutate(
        updateCarbonBudgetMutation,
        variables: {'budget': budget},
      );

      print('⚙️ TRANSACTION: Received GraphQL response');
      final budgetData = result['data']?['updateCarbonBudget'];
      if (budgetData != null) {
        print('✅ TRANSACTION: Carbon budget updated successfully');
      } else {
        print('⚠️ TRANSACTION WARNING: Budget data is null in response');
      }
      return budgetData;
    } catch (e, stackTrace) {
      print('❌ TRANSACTION ERROR: Failed to update carbon budget: $e');
      print('❌ TRANSACTION ERROR: Stack trace: $stackTrace');
      print('❌ TRANSACTION ERROR: Budget value: $budget');
      rethrow;
    }
  }

  Future<Transaction?> getTransaction(String id) async {
    print('🔍 TRANSACTION: Fetching single transaction with ID: $id');
    try {
      print('🔍 TRANSACTION: Sending getTransaction query...');
      final result = await _graphQLService.query(
        getTransactionQuery,
        variables: {'id': id},
      );

      print('🔍 TRANSACTION: Received GraphQL response');
      final transactionData = result['data']?['getTransaction'];
      if (transactionData != null) {
        print('✅ TRANSACTION: Transaction retrieved successfully');
        print('✅ TRANSACTION: Amount: €${transactionData['amount']}, Category: ${transactionData['category']}');
        return Transaction.fromJson(transactionData);
      } else {
        print('⚠️ TRANSACTION WARNING: Transaction not found');
      }

      return null;
    } catch (e, stackTrace) {
      print('❌ TRANSACTION ERROR: Failed to fetch transaction: $e');
      print('❌ TRANSACTION ERROR: Stack trace: $stackTrace');
      print('❌ TRANSACTION ERROR: Transaction ID: $id');
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
    print('✏️ TRANSACTION: Updating transaction ID: $id');
    print('✏️ TRANSACTION: New values - Amount: €$amount, Category: $category, Merchant: $merchant');
    try {
      print('✏️ TRANSACTION: Sending updateTransaction mutation...');
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

      print('✏️ TRANSACTION: Received GraphQL response');
      final transactionData = result['data']?['updateTransaction'];
      if (transactionData != null) {
        print('✅ TRANSACTION: Transaction updated successfully');
        print('✅ TRANSACTION: New carbon footprint: ${transactionData['carbonFootprint']} g CO2e');
        return Transaction.fromJson(transactionData);
      } else {
        print('⚠️ TRANSACTION WARNING: Update response data is null');
      }

      return null;
    } catch (e, stackTrace) {
      print('❌ TRANSACTION ERROR: Failed to update transaction: $e');
      print('❌ TRANSACTION ERROR: Stack trace: $stackTrace');
      print('❌ TRANSACTION ERROR: Transaction ID: $id');
      rethrow;
    }
  }

  Future<bool> deleteTransaction(String id) async {
    print('🗑️ TRANSACTION: Deleting transaction with ID: $id');
    try {
      print('🗑️ TRANSACTION: Sending deleteTransaction mutation...');
      final result = await _graphQLService.mutate(
        deleteTransactionMutation,
        variables: {'id': id},
      );

      print('🗑️ TRANSACTION: Received GraphQL response');
      final deleted = result['data']?['deleteTransaction'] == true;
      if (deleted) {
        print('✅ TRANSACTION: Transaction deleted successfully');
      } else {
        print('⚠️ TRANSACTION WARNING: Transaction deletion failed or returned false');
      }
      return deleted;
    } catch (e, stackTrace) {
      print('❌ TRANSACTION ERROR: Failed to delete transaction: $e');
      print('❌ TRANSACTION ERROR: Stack trace: $stackTrace');
      print('❌ TRANSACTION ERROR: Transaction ID: $id');
      rethrow;
    }
  }

  Future<List<double>> getMonthlyHistoricalCarbon(String userId) async {
    print('📅 TRANSACTION: Fetching monthly historical carbon for user: $userId');
    try {
      print('📅 TRANSACTION: Sending getMonthlyHistoricalCarbon query...');
      final result = await _graphQLService.query(
        getMonthlyHistoricalCarbonQuery,
        variables: {'userId': userId},
      );

      print('📅 TRANSACTION: Received GraphQL response');
      final monthlyData =
          result['data']?['getMonthlyHistoricalCarbon'] as List?;
      if (monthlyData != null) {
        final data = monthlyData.map((value) => (value as num).toDouble()).toList();
        print('✅ TRANSACTION: Retrieved ${data.length} months of historical data');
        return data;
      } else {
        print('⚠️ TRANSACTION WARNING: No monthly data in response, returning zeros');
      }

      return List.filled(12, 0.0);
    } catch (e, stackTrace) {
      print('❌ TRANSACTION ERROR: Failed to fetch monthly historical carbon: $e');
      print('❌ TRANSACTION ERROR: Stack trace: $stackTrace');
      print('❌ TRANSACTION ERROR: User ID: $userId');
      rethrow;
    }
  }
}
