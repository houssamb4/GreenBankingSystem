import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:frontend/config/theme.dart';
import 'package:frontend/config/router.dart';
import 'package:frontend/models/models.dart';
import 'package:frontend/providers/providers.dart';
import 'package:frontend/widgets/components.dart';

class TransactionsListScreen extends ConsumerStatefulWidget {
  const TransactionsListScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TransactionsListScreen> createState() =>
      _TransactionsListScreenState();
}

class _TransactionsListScreenState
    extends ConsumerState<TransactionsListScreen> {
  late TextEditingController _searchController;
  Category? _selectedCategory;
  DateTimeRange? _dateRange;
  bool _showFilters = false;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedCategory = null;
      _dateRange = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionsAsync = ref.watch(transactionsProvider);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        elevation: 1,
        shadowColor: AppTheme.borderLight,
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              // Export CSV
            },
            tooltip: 'Export CSV',
          ),
        ],
      ),
      body: Column(
        children: [
          // Search and Filter Bar
          Container(
            padding: const EdgeInsets.all(AppTheme.paddingMedium),
            color: AppTheme.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search merchant...',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                          )
                        : null,
                  ),
                  onChanged: (value) => setState(() {}),
                ),
                const SizedBox(height: AppTheme.paddingMedium),

                // Filter Toggle
                InkWell(
                  onTap: () => setState(() => _showFilters = !_showFilters),
                  child: Row(
                    children: [
                      Icon(
                        _showFilters ? Icons.expand_less : Icons.expand_more,
                        color: AppTheme.primaryDarkGreen,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Filters',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primaryDarkGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const Spacer(),
                      if (_selectedCategory != null || _dateRange != null)
                        TextButton(
                          onPressed: _clearFilters,
                          child: const Text('Clear All'),
                        ),
                    ],
                  ),
                ),

                // Filter Options
                if (_showFilters) ...[
                  const SizedBox(height: AppTheme.paddingMedium),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        // Category Filter
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppTheme.paddingMedium,
                          ),
                          decoration: BoxDecoration(
                            border: Border.all(color: AppTheme.borderLight),
                            borderRadius: BorderRadius.circular(
                              AppTheme.cornerRadius,
                            ),
                          ),
                          child: DropdownButton<Category?>(
                            value: _selectedCategory,
                            hint: const Text('Category'),
                            underline: const SizedBox.shrink(),
                            items: [
                              const DropdownMenuItem(
                                value: null,
                                child: Text('All Categories'),
                              ),
                              ...Category.values.map(
                                (category) => DropdownMenuItem(
                                  value: category,
                                  child: Text(
                                    category.toString().split('.').last,
                                  ),
                                ),
                              ),
                            ],
                            onChanged: (value) =>
                                setState(() => _selectedCategory = value),
                          ),
                        ),
                        const SizedBox(width: AppTheme.paddingMedium),

                        // Date Range Filter
                        ElevatedButton.icon(
                          onPressed: () async {
                            final range = await showDateRangePicker(
                              context: context,
                              firstDate: DateTime(2020),
                              lastDate: DateTime.now(),
                              initialDateRange: _dateRange,
                            );
                            if (range != null) {
                              setState(() => _dateRange = range);
                            }
                          },
                          icon: const Icon(Icons.calendar_today),
                          label: Text(
                            _dateRange == null
                                ? 'Date Range'
                                : '${DateFormat('MMM d').format(_dateRange!.start)} - ${DateFormat('MMM d').format(_dateRange!.end)}',
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.white,
                            foregroundColor: AppTheme.primaryDarkGreen,
                            side: const BorderSide(color: AppTheme.borderLight),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.borderLight),

          // Transactions List
          Expanded(
            child: transactionsAsync.when(
              data: (transactions) {
                final filtered = transactions
                    .where((tx) {
                      if (_searchController.text.isNotEmpty &&
                          !tx.merchant.toLowerCase().contains(
                            _searchController.text.toLowerCase(),
                          )) {
                        return false;
                      }
                      if (_selectedCategory != null &&
                          tx.category != _selectedCategory) {
                        return false;
                      }
                      if (_dateRange != null &&
                          (tx.date.isBefore(_dateRange!.start) ||
                              tx.date.isAfter(_dateRange!.end))) {
                        return false;
                      }
                      return true;
                    })
                    .toList()
                    .cast<Transaction>();

                if (filtered.isEmpty) {
                  return EmptyState(
                    title: 'No Transactions',
                    message: 'No transactions match your filters.',
                    icon: Icons.receipt,
                    action: ElevatedButton(
                      onPressed: () => context.go(Routes.addTransaction),
                      child: const Text('Add First Transaction'),
                    ),
                  );
                }

                return isDesktop
                    ? _DesktopTransactionsTable(transactions: filtered)
                    : _MobileTransactionsList(transactions: filtered);
              },
              loading: () =>
                  const LoadingState(message: 'Loading transactions...'),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error loading transactions: $error'),
                    const SizedBox(height: AppTheme.paddingMedium),
                    ElevatedButton(
                      onPressed: () => ref.refresh(transactionsProvider),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(Routes.addTransaction),
        label: const Text('Add Transaction'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class _DesktopTransactionsTable extends StatelessWidget {
  final List<Transaction> transactions;

  const _DesktopTransactionsTable({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        margin: const EdgeInsets.all(AppTheme.paddingMedium),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
          boxShadow: const [AppTheme.softShadow],
        ),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: DataTable(
            headingRowColor: MaterialStateColor.resolveWith(
              (states) => AppTheme.primaryDarkGreen.withOpacity(0.05),
            ),
            columns: [
              DataColumn(
                label: Text(
                  'Date',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: AppTheme.textDark),
                ),
              ),
              DataColumn(
                label: Text(
                  'Merchant',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: AppTheme.textDark),
                ),
              ),
              DataColumn(
                label: Text(
                  'Category',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: AppTheme.textDark),
                ),
              ),
              DataColumn(
                label: Text(
                  'Amount',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: AppTheme.textDark),
                ),
                numeric: true,
              ),
              DataColumn(
                label: Text(
                  'CO₂ Estimated',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: AppTheme.textDark),
                ),
                numeric: true,
              ),
              DataColumn(
                label: Text(
                  'Actions',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: AppTheme.textDark),
                ),
              ),
            ],
            rows: transactions
                .map(
                  (tx) => DataRow(
                    onSelectChanged: (selected) {
                      context.go(Routes.transactionDetailPath(tx.id));
                    },
                    cells: [
                      DataCell(
                        Text(
                          DateFormat('MMM d, yyyy').format(tx.date),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      DataCell(
                        Text(
                          tx.merchant,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                      DataCell(
                        CategoryBadge(category: tx.category, compact: true),
                      ),
                      DataCell(
                        Text(
                          '${tx.amount.toStringAsFixed(2)} ${tx.currency}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                      DataCell(
                        Text(
                          _formatCO2(tx.estimatedCO2grams),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppTheme.primaryDarkGreen,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      DataCell(
                        PopupMenuButton(
                          itemBuilder: (context) => [
                            PopupMenuItem(
                              onTap: () {
                                context.go(Routes.transactionDetailPath(tx.id));
                              },
                              child: const Text('View Details'),
                            ),
                            PopupMenuItem(
                              child: const Text('Edit'),
                              onTap: () {
                                // TODO: Implement edit
                              },
                            ),
                            PopupMenuItem(
                              child: const Text(
                                'Delete',
                                style: TextStyle(color: AppTheme.errorRed),
                              ),
                              onTap: () {
                                // TODO: Implement delete
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ),
    );
  }

  String _formatCO2(double grams) {
    if (grams >= 1000) {
      return '${(grams / 1000).toStringAsFixed(2)} kg';
    }
    return '${grams.toStringAsFixed(0)} g';
  }
}

class _MobileTransactionsList extends StatelessWidget {
  final List<Transaction> transactions;

  const _MobileTransactionsList({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.paddingMedium),
          child: Dismissible(
            key: Key(transaction.id),
            background: Container(
              decoration: BoxDecoration(
                color: AppTheme.errorRed,
                borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
              ),
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.only(right: AppTheme.paddingMedium),
              child: const Icon(Icons.delete, color: AppTheme.white),
            ),
            onDismissed: (direction) {
              // TODO: Implement delete
            },
            child: TransactionCard(
              transaction: transaction,
              onTap: () =>
                  context.go(Routes.transactionDetailPath(transaction.id)),
              onEdit: () {
                // TODO: Implement edit
              },
              onDelete: () {
                // TODO: Implement delete
              },
            ),
          ),
        );
      },
    );
  }
}
