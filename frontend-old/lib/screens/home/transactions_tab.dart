import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import '../../config/graphql_config.dart';
import '../../models/transaction_model.dart';
import '../../services/auth_service.dart';
import '../../utils/app_colors.dart';
import '../transactions/add_transaction_screen.dart';

class TransactionsTab extends StatelessWidget {
  const TransactionsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    final userId = authService.user?.id;

    if (userId == null) {
      return const Center(child: Text('User not found'));
    }

    return Scaffold(
      body: Query(
        options: QueryOptions(
          document: gql(GraphQLConfig.getUserTransactionsQuery),
          variables: {'userId': userId},
          pollInterval: const Duration(seconds: 10),
        ),
        builder: (result, {fetchMore, refetch}) {
          if (result.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (result.hasException) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading transactions',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    result.exception.toString(),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => refetch!(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final transactions = (result.data!['getUserTransactions'] as List)
              .map((e) => Transaction.fromJson(e))
              .toList();

          if (transactions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 80,
                    color: AppColors.textHint,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No transactions yet',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add your first transaction to start tracking',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textHint,
                        ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await refetch!();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return _TransactionCard(transaction: transaction);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTransactionScreen(),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Add Transaction'),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  final Transaction transaction;

  const _TransactionCard({required this.transaction});

  IconData _getCategoryIcon(String category) {
    switch (category.toUpperCase()) {
      case 'FOOD':
        return Icons.restaurant;
      case 'TRANSPORT':
        return Icons.directions_car;
      case 'SHOPPING':
        return Icons.shopping_bag;
      case 'ENERGY':
        return Icons.bolt;
      case 'SERVICES':
        return Icons.room_service;
      case 'ENTERTAINMENT':
        return Icons.movie;
      case 'TRAVEL':
        return Icons.flight;
      case 'HEALTHCARE':
        return Icons.local_hospital;
      case 'EDUCATION':
        return Icons.school;
      case 'TECHNOLOGY':
        return Icons.computer;
      case 'FASHION':
        return Icons.checkroom;
      case 'HOME':
        return Icons.home;
      case 'GREEN':
        return Icons.eco;
      default:
        return Icons.payment;
    }
  }

  Color _getCarbonColor(double carbonFootprint) {
    if (carbonFootprint < 5) return AppColors.lowCarbon;
    if (carbonFootprint < 15) return AppColors.mediumCarbon;
    return AppColors.highCarbon;
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('MMM dd, yyyy • HH:mm');
    final carbonColor = _getCarbonColor(transaction.carbonFootprint);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getCategoryIcon(transaction.category),
            color: AppColors.primary,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                transaction.merchant ?? transaction.category,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            Text(
              '\$${transaction.amount.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            if (transaction.description != null)
              Text(
                transaction.description!,
                style: TextStyle(color: AppColors.textSecondary),
              ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  Icons.co2,
                  size: 16,
                  color: carbonColor,
                ),
                const SizedBox(width: 4),
                Text(
                  '${transaction.carbonFootprint.toStringAsFixed(2)} kg CO₂',
                  style: TextStyle(
                    color: carbonColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  dateFormat.format(transaction.transactionDate),
                  style: TextStyle(
                    color: AppColors.textHint,
                    fontSize: 12,
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
