import 'package:flutter/material.dart';
import 'package:greenpay/core/theme/global_colors.dart';

class TransactionDetailsPage extends StatelessWidget {
  final String transactionId;

  const TransactionDetailsPage({
    Key? key,
    required this.transactionId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Mock data - in real app, fetch based on transactionId
    final transaction = {
      'merchant': 'Amazon Shopping',
      'amount': '\$47.99',
      'date': 'Yesterday, 3:45 PM',
      'totalCarbon': '+3.5 kg CO₂',
      'icon': Icons.shopping_bag,
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Details'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: GlobalColors.text,
        elevation: 0,
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
                      transaction['icon'] as IconData,
                      color: const Color(0xFF10B981),
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    transaction['merchant'],
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: GlobalColors.text,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    transaction['date'],
                    style: const TextStyle(
                      fontSize: 13,
                      color: GlobalColors.textSecondary,
                    ),
                  ),
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
                            transaction['amount'],
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
                            transaction['totalCarbon'],
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
            // Carbon Breakdown Card
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
                    'Carbon Emission Breakdown',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: GlobalColors.text,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildBreakdownItem('Transport', '+1.2 kg CO₂', 0.35),
                  const SizedBox(height: 12),
                  _buildBreakdownItem('Energy', '+0.8 kg CO₂', 0.23),
                  const SizedBox(height: 12),
                  _buildBreakdownItem('Packaging', '+1.5 kg CO₂', 0.42),
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

  Widget _buildBreakdownItem(String label, String carbon, double percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: GlobalColors.text,
              ),
            ),
            Text(
              carbon,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFFEF4444),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            minHeight: 6,
            backgroundColor: const Color(0xFFE5E7EB),
            valueColor: const AlwaysStoppedAnimation<Color>(
              Color(0xFFEF4444),
            ),
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
