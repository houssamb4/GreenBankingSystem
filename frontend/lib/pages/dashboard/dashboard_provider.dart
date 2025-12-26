import 'package:flutter/material.dart';
import 'package:greenpay/core/models/transaction.dart';
import 'package:greenpay/core/models/user.dart';
import 'package:greenpay/core/services/auth_service.dart';
import 'package:greenpay/core/services/token_storage_service.dart';
import 'package:greenpay/core/services/transaction_service.dart';

class DashboardProvider extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;
  final TransactionService _transactionService = TransactionService.instance;
  final TokenStorageService _tokenStorage = TokenStorageService.instance;

  User? _currentUser;
  CarbonStats? _carbonStats;
  List<Transaction> _transactions = [];
  List<CategoryBreakdown> _categoryBreakdown = [];
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  CarbonStats? get carbonStats => _carbonStats;
  List<Transaction> get transactions => _transactions;
  List<CategoryBreakdown> get categoryBreakdown => _categoryBreakdown;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Derived properties
  String get userName => _currentUser?.fullName ?? 'User';
  String get userEmail => _currentUser?.email ?? '';
  String get userInitials {
    if (_currentUser == null) return 'U';
    final firstName = _currentUser!.firstName;
    final lastName = _currentUser!.lastName;
    return '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
        .toUpperCase();
  }

  double get ecoScore => _carbonStats?.ecoScore ?? _currentUser?.ecoScore ?? 0;
  double get monthlyCarbon => _carbonStats?.monthlyCarbon ?? 0;
  double get carbonBudget =>
      _carbonStats?.carbonBudget ?? _currentUser?.monthlyCarbonBudget ?? 100;
  double get carbonPercentage => _carbonStats?.carbonPercentage ?? 0;
  double get totalCarbonSaved => _currentUser?.totalCarbonSaved ?? 0;

  List<Transaction> get recentTransactions => _transactions.take(5).toList();

  Future<void> loadDashboardData() async {
    print('📊 DASHBOARD PROVIDER: Loading dashboard data...');
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get user ID from storage
      print('📊 DASHBOARD PROVIDER: Retrieving user ID from storage...');
      final userId = await _tokenStorage.getUserId();
      print('📊 DASHBOARD PROVIDER: User ID: $userId');

      // Load user data
      print('📊 DASHBOARD PROVIDER: Loading user data...');
      final userData = await _authService.getCurrentUser();
      if (userData != null) {
        _currentUser = User.fromJson(userData);
        print('✅ DASHBOARD PROVIDER: User data loaded - ${_currentUser?.fullName}');
      } else {
        print('⚠️ DASHBOARD PROVIDER: No user data returned');
      }

      // Load carbon stats
      if (userId != null) {
        print('📊 DASHBOARD PROVIDER: Loading carbon stats...');
        _carbonStats = await _transactionService.getCarbonStats(userId);
        if (_carbonStats != null) {
          print('✅ DASHBOARD PROVIDER: Carbon stats loaded - Monthly: ${_carbonStats?.monthlyCarbon} g CO2e');
        }

        print('📊 DASHBOARD PROVIDER: Loading transactions...');
        _transactions = await _transactionService.getUserTransactions(userId);
        print('✅ DASHBOARD PROVIDER: Loaded ${_transactions.length} transactions');

        print('📊 DASHBOARD PROVIDER: Loading category breakdown...');
        _categoryBreakdown =
            await _transactionService.getCategoryBreakdown(userId);
        print('✅ DASHBOARD PROVIDER: Loaded ${_categoryBreakdown.length} categories');
      } else {
        print('⚠️ DASHBOARD PROVIDER: No user ID, skipping data load');
      }

      _isLoading = false;
      print('✅ DASHBOARD PROVIDER: Dashboard data loaded successfully');
      notifyListeners();
    } catch (e, stackTrace) {
      print('❌ DASHBOARD PROVIDER ERROR: Failed to load dashboard data: $e');
      print('❌ DASHBOARD PROVIDER ERROR: Stack trace: $stackTrace');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshData() async {
    print('🔄 DASHBOARD PROVIDER: Refreshing dashboard data...');
    await loadDashboardData();
  }

  Future<Transaction?> createTransaction({
    required double amount,
    required String category,
    required String merchant,
    String? description,
  }) async {
    print('💳 DASHBOARD PROVIDER: Creating transaction...');
    print('💳 DASHBOARD PROVIDER: Amount: €$amount, Category: $category, Merchant: $merchant');
    try {
      final transaction = await _transactionService.createTransaction(
        amount: amount,
        category: category,
        merchant: merchant,
        description: description,
      );

      if (transaction != null) {
        print('✅ DASHBOARD PROVIDER: Transaction created - ID: ${transaction.id}');
        _transactions.insert(0, transaction);
        print('🔄 DASHBOARD PROVIDER: Refreshing dashboard stats...');
        await refreshData(); // Refresh stats after new transaction
        notifyListeners();
      } else {
        print('⚠️ DASHBOARD PROVIDER: Transaction creation returned null');
      }

      return transaction;
    } catch (e, stackTrace) {
      print('❌ DASHBOARD PROVIDER ERROR: Failed to create transaction: $e');
      print('❌ DASHBOARD PROVIDER ERROR: Stack trace: $stackTrace');
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> updateCarbonBudget(double budget) async {
    print('⚙️ DASHBOARD PROVIDER: Updating carbon budget to: $budget g CO2e');
    try {
      await _transactionService.updateCarbonBudget(budget);
      print('✅ DASHBOARD PROVIDER: Budget updated, refreshing data...');
      await refreshData();
    } catch (e, stackTrace) {
      print('❌ DASHBOARD PROVIDER ERROR: Failed to update carbon budget: $e');
      print('❌ DASHBOARD PROVIDER ERROR: Stack trace: $stackTrace');
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    print('🚪 DASHBOARD PROVIDER: Logging out user...');
    try {
      await _authService.logout();
      _currentUser = null;
      _carbonStats = null;
      _transactions = [];
      _categoryBreakdown = [];
      print('✅ DASHBOARD PROVIDER: User logged out, clearing dashboard data');
      notifyListeners();

      if (context.mounted) {
        print('🚪 DASHBOARD PROVIDER: Navigating to sign-in page');
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/signIn', (route) => false);
      }
    } catch (e, stackTrace) {
      print('❌ DASHBOARD PROVIDER ERROR: Logout failed: $e');
      print('❌ DASHBOARD PROVIDER ERROR: Stack trace: $stackTrace');
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
