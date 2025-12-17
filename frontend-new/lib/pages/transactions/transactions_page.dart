import 'package:flutter/material.dart';
import 'package:greenpay/core/theme/global_colors.dart';
import 'package:greenpay/widgets/app_drawer.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  String _selectedFilter = 'all';

  final List<Map<String, dynamic>> _mockTransactions = [
    {
      'id': '1',
      'merchant': 'Local Coffee Shop',
      'date': 'Today, 10:30 AM',
      'amount': '\$12.50',
      'carbonImpact': '+0.2 kg CO₂',
      'icon': Icons.local_cafe,
      'category': 'food',
      'carbonLevel': 'low',
    },
    {
      'id': '2',
      'merchant': 'Electric Car Charging',
      'date': 'Today, 08:15 AM',
      'amount': '\$8.75',
      'carbonImpact': '-2.1 kg CO₂',
      'icon': Icons.ev_station,
      'category': 'transport',
      'carbonLevel': 'low',
    },
    {
      'id': '3',
      'merchant': 'Amazon Shopping',
      'date': 'Yesterday, 3:45 PM',
      'amount': '\$47.99',
      'carbonImpact': '+3.5 kg CO₂',
      'icon': Icons.shopping_bag,
      'category': 'shopping',
      'carbonLevel': 'high',
    },
    {
      'id': '4',
      'merchant': 'Flight Booking',
      'date': 'Last week',
      'amount': '\$245.00',
      'carbonImpact': '+125 kg CO₂',
      'icon': Icons.flight_takeoff,
      'category': 'travel',
      'carbonLevel': 'critical',
    },
    {
      'id': '5',
      'merchant': 'Organic Grocery',
      'date': 'Last week',
      'amount': '\$62.30',
      'carbonImpact': '+1.1 kg CO₂',
      'icon': Icons.local_grocery_store,
      'category': 'food',
      'carbonLevel': 'low',
    },
  ];

  Color _getCarbonColor(String level) {
    switch (level) {
      case 'low':
        return const Color(0xFF10B981);
      case 'medium':
        return const Color(0xFFF59E0B);
      case 'high':
        return const Color(0xFFEF4444);
      case 'critical':
        return const Color(0xFF991B1B);
      default:
        return GlobalColors.text;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: GlobalColors.text,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () {
              // TODO: Show filter options
            },
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/transactions'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Filter chips
            Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildFilterChip('All', 'all'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Food', 'food'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Transport', 'transport'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Shopping', 'shopping'),
                    const SizedBox(width: 8),
                    _buildFilterChip('Travel', 'travel'),
                  ],
                ),
              ),
            ),
            // Transactions List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _mockTransactions.length,
              itemBuilder: (context, index) {
                final transaction = _mockTransactions[index];
                return GestureDetector(
                  onTap: () => Navigator.of(context).pushNamed(
                      '/transaction-details',
                      arguments: transaction['id']),
                  child: Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Icon
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            transaction['icon'],
                            color: const Color(0xFF10B981),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Details
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                transaction['merchant'],
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: GlobalColors.text,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                transaction['date'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: GlobalColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Amount & Carbon
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              transaction['amount'],
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: GlobalColors.text,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              transaction['carbonImpact'],
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color:
                                    _getCarbonColor(transaction['carbonLevel']),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value) {
    final isSelected = _selectedFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        setState(() {
          _selectedFilter = value;
        });
      },
      backgroundColor: Colors.white,
      selectedColor: const Color(0xFF10B981).withOpacity(0.1),
      labelStyle: TextStyle(
        color:
            isSelected ? const Color(0xFF10B981) : GlobalColors.textSecondary,
        fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
      ),
      side: BorderSide(
        color: isSelected ? const Color(0xFF10B981) : const Color(0xFFE5E7EB),
      ),
    );
  }
}
