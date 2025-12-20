import 'package:flutter/material.dart';
import 'package:greenpay/core/theme/global_colors.dart';
import 'package:greenpay/core/services/transaction_service.dart';
import 'package:greenpay/core/models/transaction.dart' as models;
import 'package:intl/intl.dart';

class TransactionDetailsPage extends StatefulWidget {
  final String transactionId;

  const TransactionDetailsPage({
    Key? key,
    required this.transactionId,
  }) : super(key: key);

  @override
  State<TransactionDetailsPage> createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  final TransactionService _transactionService = TransactionService.instance;
  models.Transaction? _transaction;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadTransaction();
  }

  Future<void> _loadTransaction() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final transaction =
          await _transactionService.getTransaction(widget.transactionId);
      setState(() {
        _transaction = transaction;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category.toLowerCase()) {
      case 'shopping':
      case 'retail':
        return Icons.shopping_bag;
      case 'food':
      case 'dining':
      case 'groceries':
        return Icons.restaurant;
      case 'transport':
      case 'transportation':
        return Icons.directions_car;
      case 'entertainment':
        return Icons.movie;
      case 'utilities':
        return Icons.water_drop;
      default:
        return Icons.shopping_bag;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Transaction Details'),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: GlobalColors.text,
          elevation: 0,
        ),
        body: Center(
          child: CircularProgressIndicator(
            color: const Color(0xFF10B981),
          ),
        ),
      );
    }

    if (_error != null || _transaction == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Transaction Details'),
          centerTitle: true,
          backgroundColor: Colors.white,
          foregroundColor: GlobalColors.text,
          elevation: 0,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Failed to load transaction',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: GlobalColors.text,
                ),
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: TextStyle(
                    fontSize: 14,
                    color: GlobalColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _loadTransaction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                ),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    final dateFormat = DateFormat('MMM dd, yyyy \' at\' h:mm a');
    final amountFormat = NumberFormat.currency(
        symbol:
            _transaction!.currency == 'USD' ? '\$' : _transaction!.currency);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: GlobalColors.text,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_outlined),
            onPressed: () => _showEditDialog(context),
            tooltip: 'Edit Transaction',
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: Colors.red),
            onPressed: () => _showDeleteConfirmation(context),
            tooltip: 'Delete Transaction',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Transaction Header Card
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3F4F6),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      _getCategoryIcon(_transaction!.category),
                      color: const Color(0xFF10B981),
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _transaction!.merchant,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: GlobalColors.text,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _transaction!.category,
                    style: const TextStyle(
                      fontSize: 13,
                      color: GlobalColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    dateFormat.format(_transaction!.transactionDate),
                    style: const TextStyle(
                      fontSize: 13,
                      color: GlobalColors.textSecondary,
                    ),
                  ),
                  if (_transaction!.description != null &&
                      _transaction!.description!.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Text(
                      _transaction!.description!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: GlobalColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'Amount',
                            style: TextStyle(
                              fontSize: 12,
                              color: GlobalColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            amountFormat.format(_transaction!.amount),
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: GlobalColors.text,
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          const Text(
                            'Carbon Impact',
                            style: TextStyle(
                              fontSize: 12,
                              color: GlobalColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '+${_transaction!.carbonFootprint.toStringAsFixed(2)} kg CO₂',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFEF4444),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Carbon Info Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE5E7EB)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Carbon Emission Info',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: GlobalColors.text,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildInfoRow('Category', _transaction!.category),
                  const SizedBox(height: 12),
                  _buildInfoRow('Total Carbon',
                      '${_transaction!.carbonFootprint.toStringAsFixed(2)} kg CO₂'),
                  const SizedBox(height: 12),
                  _buildInfoRow('Transaction ID', _transaction!.id),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Tips Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF10B981).withOpacity(0.3),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(
                        Icons.lightbulb_outline,
                        color: Color(0xFF10B981),
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'How to Reduce Impact',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF10B981),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildTip('Shop locally to reduce transport emissions'),
                  const SizedBox(height: 8),
                  _buildTip('Use eco-friendly packaging options'),
                  const SizedBox(height: 8),
                  _buildTip('Consider group purchases to consolidate shipping'),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: GlobalColors.textSecondary,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: GlobalColors.text,
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  Widget _buildTip(String text) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline,
          color: Color(0xFF10B981),
          size: 16,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF10B981),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
