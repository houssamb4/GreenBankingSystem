import 'package:flutter/material.dart';
import 'package:greenpay/core/theme/global_colors.dart';
import 'package:greenpay/widgets/app_drawer.dart';

class CarbonImpactPage extends StatefulWidget {
  const CarbonImpactPage({Key? key}) : super(key: key);

  @override
  State<CarbonImpactPage> createState() => _CarbonImpactPageState();
}

class _CarbonImpactPageState extends State<CarbonImpactPage> {
  int _selectedMonth = DateTime.now().month;

  final List<String> _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final List<double> _monthlyData = [
    45.2,
    38.5,
    52.3,
    41.8,
    55.6,
    48.2,
    62.1,
    58.5,
    51.2,
    45.8,
    48.3,
    42.5
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carbon Impact'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: GlobalColors.text,
        elevation: 0,
      ),
      drawer: const AppDrawer(currentRoute: '/impact'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Month Selector
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  12,
                  (index) => Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _selectedMonth = index + 1);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedMonth == index + 1
                              ? const Color(0xFF10B981)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _selectedMonth == index + 1
                                ? const Color(0xFF10B981)
                                : const Color(0xFFE5E7EB),
                          ),
                        ),
                        child: Text(
                          _months[index],
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: _selectedMonth == index + 1
                                ? Colors.white
                                : GlobalColors.textSecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Total CO₂ Card
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
                  const Text(
                    'Total CO₂ This Month',
                    style: TextStyle(
                      fontSize: 14,
                      color: GlobalColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    '${_monthlyData[_selectedMonth - 1].toStringAsFixed(1)} kg',
                    style: const TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: GlobalColors.text,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Last month: 48.3 kg',
                    style: TextStyle(
                      fontSize: 12,
                      color: GlobalColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Mini chart
                  SizedBox(
                    height: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: List.generate(
                        12,
                        (index) {
                          final max =
                              _monthlyData.reduce((a, b) => a > b ? a : b);
                          final height = (_monthlyData[index] / max) * 50 + 10;
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Container(
                                width: 20,
                                height: height,
                                decoration: BoxDecoration(
                                  color: _selectedMonth == index + 1
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFE5E7EB),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _months[index],
                                style: const TextStyle(fontSize: 8),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Impact Categories
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
                    'Category Breakdown',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: GlobalColors.text,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildCategoryItem(
                    'Shopping',
                    '18.5 kg',
                    Icons.shopping_bag,
                    0.35,
                  ),
                  const SizedBox(height: 12),
                  _buildCategoryItem(
                    'Food & Dining',
                    '12.3 kg',
                    Icons.restaurant,
                    0.23,
                  ),
                  const SizedBox(height: 12),
                  _buildCategoryItem(
                    'Transportation',
                    '8.7 kg',
                    Icons.directions_car,
                    0.16,
                  ),
                  const SizedBox(height: 12),
                  _buildCategoryItem(
                    'Travel',
                    '2.1 kg',
                    Icons.flight_takeoff,
                    0.04,
                  ),
                  const SizedBox(height: 12),
                  _buildCategoryItem(
                    'Utilities',
                    '0.9 kg',
                    Icons.lightbulb,
                    0.02,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Comparison Card
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
                  const Text(
                    'Your Performance',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildComparisonRow(
                    'vs. Last Month',
                    '+4.2%',
                    false,
                  ),
                  const SizedBox(height: 8),
                  _buildComparisonRow(
                    'vs. Average User',
                    '-12.3%',
                    true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(
    String label,
    String amount,
    IconData icon,
    double percentage,
  ) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: const Color(0xFFF3F4F6),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: const Color(0xFF10B981),
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: GlobalColors.text,
                ),
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percentage,
                  minHeight: 4,
                  backgroundColor: const Color(0xFFE5E7EB),
                  valueColor: const AlwaysStoppedAnimation<Color>(
                    Color(0xFF10B981),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          amount,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: GlobalColors.text,
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonRow(String label, String value, bool isPositive) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Color(0xFF10B981),
          ),
        ),
        Row(
          children: [
            Icon(
              isPositive ? Icons.trending_down : Icons.trending_up,
              color: isPositive ? Colors.green : Colors.red,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isPositive ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
