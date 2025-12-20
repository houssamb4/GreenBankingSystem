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
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // Get user ID from storage
      final userId = await _tokenStorage.getUserId();
      print('DEBUG: User ID from storage: $userId');

      // Load user data
      final userData = await _authService.getCurrentUser();
      print('DEBUG: User data loaded: $userData');
      if (userData != null) {
        _currentUser = User.fromJson(userData);
        print('DEBUG: Current user: ${_currentUser?.fullName}');
      }

      // Load carbon stats
      if (userId != null) {
        print('DEBUG: Loading carbon stats for user: $userId');
        _carbonStats = await _transactionService.getCarbonStats(userId);
        print('DEBUG: Carbon stats: ${_carbonStats?.monthlyCarbon}');
        
        print('DEBUG: Loading transactions for user: $userId');
        _transactions = await _transactionService.getUserTransactions(userId);
        print('DEBUG: Loaded ${_transactions.length} transactions');
        
        print('DEBUG: Loading category breakdown for user: $userId');
        _categoryBreakdown =
            await _transactionService.getCategoryBreakdown(userId);
        print('DEBUG: Loaded ${_categoryBreakdown.length} categories');
      }

      _isLoading = false;
      notifyListeners();
    } catch (e, stackTrace) {
      print('DEBUG ERROR: $e');
      print('DEBUG STACK: $stackTrace');
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refreshData() async {
    await loadDashboardData();
  }

  Future<Transaction?> createTransaction({
    required double amount,
    required String category,
    required String merchant,
    String? description,
  }) async {
    try {
      print('DEBUG: Creating transaction: amount=$amount, category=$category, merchant=$merchant');
      final transaction = await _transactionService.createTransaction(
        amount: amount,
        category: category,
        merchant: merchant,
        description: description,
      );

      if (transaction != null) {
        print('DEBUG: Transaction created successfully: ${transaction.id}');
        _transactions.insert(0, transaction);
        await refreshData(); // Refresh stats after new transaction
        notifyListeners();
      } else {
        print('DEBUG: Transaction creation returned null');
      }

      return transaction;
    } catch (e, stackTrace) {
      print('DEBUG ERROR creating transaction: $e');
      print('DEBUG STACK: $stackTrace');
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> updateCarbonBudget(double budget) async {
    try {
      await _transactionService.updateCarbonBudget(budget);
      await refreshData();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    await _authService.logout();
    _currentUser = null;
    _carbonStats = null;
    _transactions = [];
    _categoryBreakdown = [];
    notifyListeners();

    if (context.mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/signIn', (route) => false);
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
