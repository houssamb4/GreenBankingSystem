import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/config/theme.dart';
import 'package:frontend/config/router.dart';
import 'package:frontend/widgets/components.dart';
import 'package:frontend/models/models.dart';

class TransactionDetailScreen extends StatelessWidget {
  final String transactionId;

  const TransactionDetailScreen({Key? key, required this.transactionId})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock transaction data - replace with GraphQL query
    final transaction = Transaction(
      id: transactionId,
      date: DateTime.now(),
      amount: 125.50,
      currency: 'EUR',
      merchant: 'Restaurant XYZ',
      category: Category.food,
      paymentMethod: PaymentMethod.creditCard,
      estimatedCO2grams: 18750, // 18.75 kg
      createdAt: DateTime.now(),
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        elevation: 1,
        shadowColor: AppTheme.borderLight,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
                boxShadow: const [AppTheme.softShadow],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            transaction.merchant,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            transaction.date.toString().split(' ')[0],
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        ],
                      ),
                      CategoryBadge(category: transaction.category),
                    ],
                  ),
                  const SizedBox(height: AppTheme.paddingLarge),
                  const Divider(color: AppTheme.borderLight),
                  const SizedBox(height: AppTheme.paddingMedium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Amount',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        '${transaction.amount.toStringAsFixed(2)} ${transaction.currency}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.paddingMedium),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Payment Method',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        transaction.paymentMethod.toString().split('.').last,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.paddingXLarge),

            // Carbon Details
            CarbonDetailAccordion(transaction: transaction),
            const SizedBox(height: AppTheme.paddingXLarge),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Edit transaction
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                  ),
                ),
                const SizedBox(width: AppTheme.paddingMedium),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ConfirmDialog(
                          title: 'Delete Transaction',
                          message:
                              'Are you sure you want to delete this transaction?',
                          onConfirm: () {
                            context.go(Routes.transactions);
                          },
                          confirmText: 'Delete',
                          isDestructive: true,
                        ),
                      );
                    },
                    icon: const Icon(Icons.delete),
                    label: const Text('Delete'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.errorRed,
                    ),
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
