import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:greenpay/core/models/transaction.dart';
import 'package:greenpay/core/services/token_storage_service.dart';
import 'package:greenpay/core/services/transaction_service.dart';
import 'package:greenpay/core/services/auth_service.dart';
import 'package:greenpay/core/theme/asana_colors.dart';
import 'package:greenpay/widgets/sidebar.dart';

class TransactionsProvider extends ChangeNotifier {
  final TransactionService _transactionService = TransactionService.instance;
  final TokenStorageService _tokenStorage = TokenStorageService.instance;
  final AuthService _authService = AuthService.instance;

  List<Transaction> _transactions = [];
  bool _isLoading = false;
  String? _error;
  String _selectedFilter = 'all';

  List<Transaction> get transactions => _filteredTransactions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedFilter => _selectedFilter;

  List<Transaction> get _filteredTransactions {
    if (_selectedFilter == 'all') return _transactions;
    return _transactions
        .where((t) => t.category.toLowerCase() == _selectedFilter.toLowerCase())
        .toList();
  }

  Future<void> loadTransactions() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userId = await _tokenStorage.getUserId();
      if (userId != null) {
        _transactions = await _transactionService.getUserTransactions(userId);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void setFilter(String filter) {
    _selectedFilter = filter;
    notifyListeners();
  }

  Future<Transaction?> createTransaction({
    required double amount,
    required String category,
    required String merchant,
    String? description,
  }) async {
    try {
      final transaction = await _transactionService.createTransaction(
        amount: amount,
        category: category,
        merchant: merchant,
        description: description,
      );
      if (transaction != null) {
        _transactions.insert(0, transaction);
        notifyListeners();
      }
      return transaction;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> logout(BuildContext context) async {
    await _authService.logout();
    _transactions = [];
    notifyListeners();

    if (context.mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/signIn', (route) => false);
    }
  }
}

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  late TransactionsProvider _provider;
  bool _sidebarExpanded = true;

  @override
  void initState() {
    super.initState();
    _provider = TransactionsProvider();
    _provider.loadTransactions();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Consumer<TransactionsProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: AsanaColors.pageBg,
            body: Row(
              children: [
                AsanaSidebar(
                  currentRoute: '/transactions',
                  isExpanded: _sidebarExpanded,
                  onExpandedChanged: (expanded) {
                    setState(() {
                      _sidebarExpanded = expanded;
                    });
                  },
                  onLogout: () async {
                    await _provider.logout(context);
                  },
                ),
                Expanded(
                  child: Column(
                    children: [
                      _buildTopBar(provider),
                      Expanded(
                        child: _buildContent(provider),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar(TransactionsProvider provider) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AsanaColors.border),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Transactions',
            style: TextStyle(
              color: AsanaColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          _buildFilterChips(provider),
          const SizedBox(width: 16),
          _buildTopBarButton(Icons.add, 'Add Transaction', AsanaColors.green,
              () {
            _showCreateTransactionDialog(context, provider);
          }),
        ],
      ),
    );
  }

  Widget _buildFilterChips(TransactionsProvider provider) {
    final filters = [
      ('all', 'All'),
      ('food', 'Food'),
      ('transport', 'Transport'),
      ('shopping', 'Shopping'),
      ('travel', 'Travel'),
    ];

    return Row(
      children: filters.map((filter) {
        final isSelected = provider.selectedFilter == filter.$1;
        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: FilterChip(
            label: Text(filter.$2),
            selected: isSelected,
            onSelected: (_) => provider.setFilter(filter.$1),
            backgroundColor: Colors.white,
            selectedColor: AsanaColors.green.withOpacity(0.1),
            labelStyle: TextStyle(
              color: isSelected ? AsanaColors.green : AsanaColors.textSecondary,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              fontSize: 13,
            ),
            side: BorderSide(
              color: isSelected ? AsanaColors.green : AsanaColors.border,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 4),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTopBarButton(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContent(TransactionsProvider provider) {
    if (provider.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AsanaColors.green),
      );
    }

    if (provider.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: AsanaColors.red),
            const SizedBox(height: 16),
            Text(
              'Error loading transactions',
              style: TextStyle(color: AsanaColors.textPrimary, fontSize: 16),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: provider.loadTransactions,
              child: Text('Retry', style: TextStyle(color: AsanaColors.blue)),
            ),
          ],
        ),
      );
    }

    if (provider.transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.receipt_long_outlined,
                size: 64, color: AsanaColors.textMuted),
            const SizedBox(height: 16),
            Text(
              'No transactions yet',
              style: TextStyle(
                color: AsanaColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your transactions will appear here',
              style: TextStyle(color: AsanaColors.textMuted, fontSize: 14),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => _showCreateTransactionDialog(context, provider),
              icon: const Icon(Icons.add),
              label: const Text('Add Transaction'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AsanaColors.green,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.loadTransactions,
      color: AsanaColors.green,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTransactionsSummary(provider),
            const SizedBox(height: 24),
            _buildTransactionsList(provider),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsSummary(TransactionsProvider provider) {
    final totalAmount = provider.transactions.fold<double>(
      0,
      (sum, t) => sum + t.amount,
    );
    final totalCarbon = provider.transactions.fold<double>(
      0,
      (sum, t) => sum + t.carbonFootprint,
    );

    return Row(
      children: [
        _buildSummaryCard(
          icon: Icons.receipt_long_rounded,
          iconColor: AsanaColors.blue,
          title: 'Total Transactions',
          value: provider.transactions.length.toString(),
        ),
        const SizedBox(width: 16),
        _buildSummaryCard(
          icon: Icons.payments_rounded,
          iconColor: AsanaColors.purple,
          title: 'Total Spent',
          value: '\$${totalAmount.toStringAsFixed(2)}',
        ),
        const SizedBox(width: 16),
        _buildSummaryCard(
          icon: Icons.eco_rounded,
          iconColor: AsanaColors.green,
          title: 'Carbon Footprint',
          value: '${totalCarbon.toStringAsFixed(1)} kg CO₂',
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AsanaColors.border),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AsanaColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: TextStyle(
                    color: AsanaColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList(TransactionsProvider provider) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AsanaColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Text(
                  'All Transactions',
                  style: TextStyle(
                    color: AsanaColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  '${provider.transactions.length} items',
                  style: TextStyle(
                    color: AsanaColors.textMuted,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AsanaColors.border),
          // Table header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            color: AsanaColors.pageBg,
            child: Row(
              children: [
                Expanded(flex: 3, child: _tableHeader('Merchant')),
                Expanded(flex: 2, child: _tableHeader('Category')),
                Expanded(flex: 2, child: _tableHeader('Date')),
                Expanded(flex: 2, child: _tableHeader('Amount')),
                Expanded(flex: 2, child: _tableHeader('Carbon Impact')),
              ],
            ),
          ),
          // Table body
          ...provider.transactions.map((transaction) {
            return _buildTransactionRow(transaction);
          }),
        ],
      ),
    );
  }

  Widget _tableHeader(String text) {
    return Text(
      text,
      style: TextStyle(
        color: AsanaColors.textSecondary,
        fontSize: 12,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildTransactionRow(Transaction transaction) {
    final categoryIcons = {
      'FOOD': Icons.restaurant_rounded,
      'TRANSPORT': Icons.directions_car_rounded,
      'SHOPPING': Icons.shopping_bag_rounded,
      'ENERGY': Icons.bolt_rounded,
      'TRAVEL': Icons.flight_rounded,
      'ENTERTAINMENT': Icons.movie_rounded,
      'GREEN': Icons.eco_rounded,
      'SERVICES': Icons.build_rounded,
      'HEALTHCARE': Icons.local_hospital_rounded,
      'EDUCATION': Icons.school_rounded,
      'TECHNOLOGY': Icons.computer_rounded,
      'FASHION': Icons.checkroom_rounded,
      'HOME': Icons.home_rounded,
    };

    final categoryColors = {
      'FOOD': AsanaColors.orange,
      'TRANSPORT': AsanaColors.blue,
      'SHOPPING': AsanaColors.purple,
      'ENERGY': AsanaColors.yellow,
      'TRAVEL': AsanaColors.pink,
      'ENTERTAINMENT': AsanaColors.teal,
      'GREEN': AsanaColors.green,
    };

    final color =
        categoryColors[transaction.category] ?? AsanaColors.textSecondary;
    final icon = categoryIcons[transaction.category] ?? Icons.payment_rounded;

    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(
          '/transaction-details/${transaction.id}',
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AsanaColors.border),
          ),
        ),
        child: Row(
          children: [
            // Merchant
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      transaction.merchant,
                      style: TextStyle(
                        color: AsanaColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            // Category
            Expanded(
              flex: 2,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  transaction.category.toLowerCase(),
                  style: TextStyle(
                    color: color,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Date
            Expanded(
              flex: 2,
              child: Text(
                DateFormat('MMM d, yyyy').format(transaction.transactionDate),
                style: TextStyle(
                  color: AsanaColors.textSecondary,
                  fontSize: 14,
                ),
              ),
            ),
            // Amount
            Expanded(
              flex: 2,
              child: Text(
                '-\$${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: AsanaColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            // Carbon
            Expanded(
              flex: 2,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getCarbonColor(transaction.carbonFootprint),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '+${transaction.carbonFootprint.toStringAsFixed(1)} kg',
                    style: TextStyle(
                      color: _getCarbonColor(transaction.carbonFootprint),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getCarbonColor(double carbon) {
    if (carbon <= 1) return AsanaColors.green;
    if (carbon <= 5) return AsanaColors.yellow;
    if (carbon <= 20) return AsanaColors.orange;
    return AsanaColors.red;
  }

  void _showCreateTransactionDialog(
      BuildContext context, TransactionsProvider provider) {
    final amountController = TextEditingController();
    final merchantController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'FOOD';

    final categories = [
      'FOOD',
      'TRANSPORT',
      'SHOPPING',
      'ENERGY',
      'SERVICES',
      'ENTERTAINMENT',
      'TRAVEL',
      'HEALTHCARE',
      'EDUCATION',
      'TECHNOLOGY',
      'FASHION',
      'HOME',
      'GREEN',
      'OTHER',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AsanaColors.green.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.add_circle_outline, color: AsanaColors.green),
            ),
            const SizedBox(width: 12),
            const Text('New Transaction'),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AsanaColors.green, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: merchantController,
                decoration: InputDecoration(
                  labelText: 'Merchant',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AsanaColors.green, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AsanaColors.green, width: 2),
                  ),
                ),
                items: categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (value) {
                  selectedCategory = value ?? 'FOOD';
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: AsanaColors.green, width: 2),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AsanaColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text);
              if (amount != null && merchantController.text.isNotEmpty) {
                final result = await provider.createTransaction(
                  amount: amount,
                  category: selectedCategory,
                  merchant: merchantController.text,
                  description: descriptionController.text.isNotEmpty
                      ? descriptionController.text
                      : null,
                );
                
                if (context.mounted) {
                  Navigator.pop(context);
                  if (result == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Failed to create transaction: ${provider.error ?? "Unknown error"}'),
                        backgroundColor: AsanaColors.red,
                      ),
                    );
                  } else {
                     ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Transaction created successfully'),
                        backgroundColor: AsanaColors.green,
                      ),
                    );
                  }
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AsanaColors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Create Transaction'),
          ),
        ],
      ),
    );
  }
}
