import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:frontend/config/theme.dart';
import 'package:frontend/config/router.dart';
import 'package:frontend/models/models.dart';
import 'package:frontend/providers/providers.dart';
import 'package:frontend/widgets/components.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyReportAsync = ref.watch(monthlyReportProvider(DateTime.now()));
    final recentTransactionsAsync = ref.watch(recentTransactionsProvider);
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        elevation: 1,
        shadowColor: AppTheme.borderLight,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.paddingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              _DashboardHeader(isDesktop: isDesktop),
              const SizedBox(height: AppTheme.paddingXLarge),

              // KPI Cards Section
              monthlyReportAsync.when(
                data: (report) =>
                    _KpiCardsSection(report: report, isDesktop: isDesktop),
                loading: () =>
                    const LoadingState(message: 'Loading metrics...'),
                error: (error, stack) => Text('Error loading metrics: $error'),
              ),
              const SizedBox(height: AppTheme.paddingXLarge),

              // Main Graph Section
              monthlyReportAsync.when(
                data: (report) => _GraphSection(report: report),
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => const SizedBox.shrink(),
              ),
              const SizedBox(height: AppTheme.paddingXLarge),

              // Top Categories Section
              monthlyReportAsync.when(
                data: (report) => _TopCategoriesSection(report: report),
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => const SizedBox.shrink(),
              ),
              const SizedBox(height: AppTheme.paddingXLarge),

              // Recent Transactions Section
              recentTransactionsAsync.when(
                data: (transactions) =>
                    _RecentTransactionsSection(transactions: transactions),
                loading: () =>
                    const LoadingState(message: 'Loading transactions...'),
                error: (error, stack) =>
                    Text('Error loading transactions: $error'),
              ),
              const SizedBox(height: AppTheme.paddingXLarge),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go(Routes.addTransaction),
        label: const Text('Add Transaction'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}

class _DashboardHeader extends StatelessWidget {
  final bool isDesktop;

  const _DashboardHeader({required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome back, John',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Here\'s your carbon footprint overview for ${DateFormat('MMMM yyyy').format(DateTime.now())}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
        if (isDesktop)
          ElevatedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.file_download),
            label: const Text('Export Report'),
          ),
      ],
    );
  }
}

class _KpiCardsSection extends StatelessWidget {
  final MonthlyReport report;
  final bool isDesktop;

  const _KpiCardsSection({required this.report, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Key Metrics', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: AppTheme.paddingMedium),
        isDesktop
            ? Row(
                children: [
                  Expanded(
                    child: KpiCard(
                      label: 'Total CO₂ This Month',
                      value: report.totalCO2kg.toStringAsFixed(2),
                      unit: 'kg',
                      icon: Icons.eco,
                      iconColor: AppTheme.primaryDarkGreen,
                    ),
                  ),
                  const SizedBox(width: AppTheme.paddingMedium),
                  Expanded(
                    child: KpiCard(
                      label: 'Transactions',
                      value: report.transactionCount.toString(),
                      icon: Icons.receipt,
                      iconColor: AppTheme.infoBlue,
                    ),
                  ),
                  const SizedBox(width: AppTheme.paddingMedium),
                  Expanded(
                    child: KpiCard(
                      label: 'Avg CO₂ per Transaction',
                      value: report.averageCO2PerTransaction.toStringAsFixed(0),
                      unit: 'g',
                      icon: Icons.trending_down,
                      iconColor: AppTheme.successGreen,
                      isPositive: true,
                    ),
                  ),
                ],
              )
            : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: KpiCard(
                        label: 'Total CO₂ This Month',
                        value: report.totalCO2kg.toStringAsFixed(2),
                        unit: 'kg',
                        icon: Icons.leaf,
                        iconColor: AppTheme.primaryDarkGreen,
                      ),
                    ),
                    const SizedBox(width: AppTheme.paddingMedium),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: KpiCard(
                        label: 'Transactions',
                        value: report.transactionCount.toString(),
                        icon: Icons.receipt,
                        iconColor: AppTheme.infoBlue,
                      ),
                    ),
                    const SizedBox(width: AppTheme.paddingMedium),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.7,
                      child: KpiCard(
                        label: 'Avg CO₂ per Transaction',
                        value: report.averageCO2PerTransaction.toStringAsFixed(
                          0,
                        ),
                        unit: 'g',
                        icon: Icons.trending_down,
                        iconColor: AppTheme.successGreen,
                      ),
                    ),
                  ],
                ),
              ),
      ],
    );
  }
}

class _GraphSection extends StatelessWidget {
  final MonthlyReport report;

  const _GraphSection({required this.report});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Daily CO₂ Emissions',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppTheme.paddingMedium),
        Container(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
            boxShadow: const [AppTheme.softShadow],
          ),
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: Center(
                  child: report.co2ByDay.isEmpty
                      ? Text(
                          'No data available',
                          style: Theme.of(context).textTheme.bodyMedium,
                        )
                      : _SimpleBarChart(data: report.co2ByDay),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SimpleBarChart extends StatelessWidget {
  final Map<String, double> data;

  const _SimpleBarChart({required this.data});

  @override
  Widget build(BuildContext context) {
    if (data.isEmpty) {
      return const SizedBox.shrink();
    }

    final maxValue = data.values.fold<double>(0, (a, b) => a > b ? a : b);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: data.entries.map((entry) {
        final height = (entry.value / maxValue) * 250;
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              height: height,
              width: 24,
              child: Container(
                decoration: BoxDecoration(
                  color: AppTheme.primaryLightGreen,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              entry.key.split('-').last,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        );
      }).toList(),
    );
  }
}

class _TopCategoriesSection extends StatelessWidget {
  final MonthlyReport report;

  const _TopCategoriesSection({required this.report});

  @override
  Widget build(BuildContext context) {
    final sortedCategories = report.co2ByCategory.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top Categories by CO₂',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: AppTheme.paddingMedium),
        Container(
          padding: const EdgeInsets.all(AppTheme.paddingMedium),
          decoration: BoxDecoration(
            color: AppTheme.white,
            borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
            boxShadow: const [AppTheme.softShadow],
          ),
          child: sortedCategories.isEmpty
              ? Center(
                  child: Text(
                    'No category data available',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                )
              : Column(
                  children: sortedCategories.map((entry) {
                    final percentage = (entry.value / report.totalCO2kg) * 100;
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppTheme.paddingSmall,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: CategoryBadge(category: entry.key),
                          ),
                          Expanded(
                            flex: 5,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: percentage / 100,
                                minHeight: 8,
                                backgroundColor: AppTheme.borderLight,
                                valueColor: const AlwaysStoppedAnimation<Color>(
                                  AppTheme.primaryLightGreen,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppTheme.paddingMedium),
                          Expanded(
                            flex: 2,
                            child: Text(
                              '${percentage.toStringAsFixed(1)}%',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(fontWeight: FontWeight.w600),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ),
      ],
    );
  }
}

class _RecentTransactionsSection extends StatelessWidget {
  final List<Transaction> transactions;

  const _RecentTransactionsSection({required this.transactions});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Recent Transactions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextButton(
              onPressed: () => context.go(Routes.transactions),
              child: const Text('View All'),
            ),
          ],
        ),
        const SizedBox(height: AppTheme.paddingMedium),
        if (transactions.isEmpty)
          EmptyState(
            title: 'No Transactions',
            message:
                'Start tracking your carbon footprint by adding your first transaction.',
            icon: Icons.receipt,
            action: ElevatedButton(
              onPressed: () => context.go(Routes.addTransaction),
              child: const Text('Add Transaction'),
            ),
          )
        else
          Column(
            children: transactions.map((transaction) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppTheme.paddingMedium),
                child: TransactionCard(
                  transaction: transaction,
                  onTap: () =>
                      context.go(Routes.transactionDetailPath(transaction.id)),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
