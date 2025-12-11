import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend/models/models.dart';

// User state provider
final userProvider = StateProvider<User?>((ref) => null);

// Transactions list provider
final transactionsProvider = FutureProvider<List<Transaction>>((ref) async {
  // Placeholder - will be replaced with GraphQL query
  await Future.delayed(const Duration(seconds: 1));
  return [];
});

// Monthly report provider
final monthlyReportProvider = FutureProvider.family<MonthlyReport, DateTime>((
  ref,
  month,
) async {
  // Placeholder - will be replaced with GraphQL query
  await Future.delayed(const Duration(seconds: 1));
  return MonthlyReport(
    totalCO2kg: 0,
    transactionCount: 0,
    averageCO2PerTransaction: 0,
    co2ByDay: {},
    co2ByCategory: {},
    month: month,
  );
});

// Recent transactions provider
final recentTransactionsProvider = FutureProvider<List<Transaction>>((
  ref,
) async {
  // Placeholder - will be replaced with GraphQL query
  await Future.delayed(const Duration(seconds: 1));
  return [];
});

// Transaction filter state
final transactionFiltersProvider = StateProvider((ref) => TransactionFilters());

// Add transaction form state
final addTransactionFormProvider = StateProvider((ref) => AddTransactionForm());

class TransactionFilters {
  final DateTime? startDate;
  final DateTime? endDate;
  final Category? category;
  final double? minCO2;
  final double? maxCO2;
  final String? searchQuery;

  TransactionFilters({
    this.startDate,
    this.endDate,
    this.category,
    this.minCO2,
    this.maxCO2,
    this.searchQuery,
  });

  TransactionFilters copyWith({
    DateTime? startDate,
    DateTime? endDate,
    Category? category,
    double? minCO2,
    double? maxCO2,
    String? searchQuery,
    bool clearStartDate = false,
    bool clearEndDate = false,
    bool clearCategory = false,
    bool clearMinCO2 = false,
    bool clearMaxCO2 = false,
    bool clearSearchQuery = false,
  }) {
    return TransactionFilters(
      startDate: clearStartDate ? null : (startDate ?? this.startDate),
      endDate: clearEndDate ? null : (endDate ?? this.endDate),
      category: clearCategory ? null : (category ?? this.category),
      minCO2: clearMinCO2 ? null : (minCO2 ?? this.minCO2),
      maxCO2: clearMaxCO2 ? null : (maxCO2 ?? this.maxCO2),
      searchQuery: clearSearchQuery ? null : (searchQuery ?? this.searchQuery),
    );
  }
}

class AddTransactionForm {
  final DateTime? date;
  final double? amount;
  final String? currency;
  final String? merchant;
  final Category? category;
  final PaymentMethod? paymentMethod;
  final CarbonEstimate? carbonEstimate;
  final bool autoCategory;

  AddTransactionForm({
    this.date,
    this.amount,
    this.currency = 'EUR',
    this.merchant,
    this.category,
    this.paymentMethod,
    this.carbonEstimate,
    this.autoCategory = false,
  });

  AddTransactionForm copyWith({
    DateTime? date,
    double? amount,
    String? currency,
    String? merchant,
    Category? category,
    PaymentMethod? paymentMethod,
    CarbonEstimate? carbonEstimate,
    bool? autoCategory,
    bool clearDate = false,
    bool clearAmount = false,
    bool clearMerchant = false,
    bool clearCategory = false,
    bool clearPaymentMethod = false,
    bool clearCarbonEstimate = false,
  }) {
    return AddTransactionForm(
      date: clearDate ? null : (date ?? this.date),
      amount: clearAmount ? null : (amount ?? this.amount),
      currency: currency ?? this.currency,
      merchant: clearMerchant ? null : (merchant ?? this.merchant),
      category: clearCategory ? null : (category ?? this.category),
      paymentMethod: clearPaymentMethod
          ? null
          : (paymentMethod ?? this.paymentMethod),
      carbonEstimate: clearCarbonEstimate
          ? null
          : (carbonEstimate ?? this.carbonEstimate),
      autoCategory: autoCategory ?? this.autoCategory,
    );
  }
}
