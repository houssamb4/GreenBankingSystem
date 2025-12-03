import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

import '../../config/graphql_config.dart';
import '../../models/transaction_model.dart';
import '../../services/auth_service.dart';
import '../../utils/app_colors.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userId = authService.user?.id;

    if (userId == null) {
      return const Center(child: Text('User not found'));
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Trigger refetch by rebuilding
        return Future.delayed(const Duration(milliseconds: 500));
      },
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _WelcomeCard(user: authService.user!),
            const SizedBox(height: 16),
            _CarbonStatsCard(userId: userId),
            const SizedBox(height: 16),
            _CategoryBreakdownCard(userId: userId),
          ],
        ),
      ),
    );
  }
}

class _WelcomeCard extends StatelessWidget {
  final dynamic user;

  const _WelcomeCard({required this.user});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user.firstName ?? 'User'}!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.eco, color: AppColors.success, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Eco Score: ${user.ecoScore}/100',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.getEcoScoreColor(user.ecoScore),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CarbonStatsCard extends StatelessWidget {
  final String userId;

  const _CarbonStatsCard({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(GraphQLConfig.getCarbonStatsQuery),
        variables: {'userId': userId},
        pollInterval: const Duration(seconds: 30),
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (result.hasException) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Text('Error: ${result.exception.toString()}'),
            ),
          );
        }

        final stats = CarbonStats.fromJson(result.data!['getCarbonStats']);

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Carbon Footprint',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: _StatItem(
                        icon: Icons.calendar_month,
                        label: 'This Month',
                        value: '${stats.monthlyCarbon.toStringAsFixed(2)} kg',
                        color: AppColors.getCarbonColor(stats.carbonPercentage),
                      ),
                    ),
                    Expanded(
                      child: _StatItem(
                        icon: Icons.all_inclusive,
                        label: 'Total',
                        value: '${stats.totalCarbon.toStringAsFixed(2)} kg',
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  'Monthly Budget: ${stats.carbonBudget.toStringAsFixed(0)} kg',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (stats.carbonPercentage / 100).clamp(0.0, 1.0),
                  backgroundColor: AppColors.border,
                  color: AppColors.getCarbonColor(stats.carbonPercentage),
                  minHeight: 8,
                ),
                const SizedBox(height: 8),
                Text(
                  '${stats.carbonPercentage.toStringAsFixed(1)}% of budget used',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.getCarbonColor(stats.carbonPercentage),
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
      ],
    );
  }
}

class _CategoryBreakdownCard extends StatelessWidget {
  final String userId;

  const _CategoryBreakdownCard({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        document: gql(GraphQLConfig.getCategoryBreakdownQuery),
        variables: {'userId': userId},
      ),
      builder: (result, {fetchMore, refetch}) {
        if (result.isLoading) {
          return const Card(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
          );
        }

        if (result.hasException || result.data == null) {
          return const SizedBox.shrink();
        }

        final breakdownList = (result.data!['getCategoryBreakdown'] as List)
            .map((e) => CategoryBreakdown.fromJson(e))
            .toList();

        if (breakdownList.isEmpty) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Icon(
                    Icons.pie_chart_outline,
                    size: 64,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions yet',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                ],
              ),
            ),
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Carbon by Category',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 16),
                ...breakdownList.map((breakdown) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _CategoryItem(breakdown: breakdown),
                    )),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CategoryItem extends StatelessWidget {
  final CategoryBreakdown breakdown;

  const _CategoryItem({required this.breakdown});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              breakdown.category,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Text(
              '${breakdown.totalCarbon.toStringAsFixed(2)} kg CO₂',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        LinearProgressIndicator(
          value: (breakdown.percentage / 100).clamp(0.0, 1.0),
          backgroundColor: AppColors.border,
          color: AppColors.primary,
        ),
        const SizedBox(height: 4),
        Text(
          '${breakdown.transactionCount} transactions • \$${breakdown.totalAmount.toStringAsFixed(2)}',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
              ),
        ),
      ],
    );
  }
}
