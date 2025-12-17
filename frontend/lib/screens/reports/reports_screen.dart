import 'package:flutter/material.dart';
import 'package:frontend/config/theme.dart';
import 'package:frontend/widgets/components.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  String _selectedPeriod = 'monthly';
  DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports'),
        elevation: 1,
        shadowColor: AppTheme.borderLight,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Period Selector
            Text(
              'Report Period',
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
                  Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<String>(
                          segments: const <ButtonSegment<String>>[
                            ButtonSegment<String>(
                              value: 'monthly',
                              label: Text('Monthly'),
                            ),
                            ButtonSegment<String>(
                              value: 'annual',
                              label: Text('Annual'),
                            ),
                          ],
                          selected: <String>{_selectedPeriod},
                          onSelectionChanged: (Set<String> newSelection) {
                            setState(
                              () => _selectedPeriod = newSelection.first,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.paddingMedium),
                  InkWell(
                    onTap: () async {
                      final date = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2020),
                        lastDate: DateTime.now(),
                      );
                      if (date != null) {
                        setState(() => _selectedDate = date);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.paddingMedium,
                        vertical: AppTheme.paddingMedium,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppTheme.borderLight),
                        borderRadius: BorderRadius.circular(
                          AppTheme.cornerRadius,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_selectedDate.year}-${_selectedDate.month.toString().padLeft(2, '0')}',
                          ),
                          const Icon(Icons.calendar_today),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppTheme.paddingXLarge),

            // KPI Cards
            Text('Summary', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppTheme.paddingMedium),
            Row(
              children: [
                Expanded(
                  child: KpiCard(
                    label: 'Total CO₂',
                    value: '45.2',
                    unit: 'kg',
                    icon: Icons.eco,
                    iconColor: AppTheme.primaryDarkGreen,
                  ),
                ),
                const SizedBox(width: AppTheme.paddingMedium),
                Expanded(
                  child: KpiCard(
                    label: 'Variation',
                    value: '-12.5',
                    unit: '%',
                    icon: Icons.trending_down,
                    iconColor: AppTheme.successGreen,
                    isPositive: true,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.paddingXLarge),

            // Charts Section
            Text(
              'Daily Emissions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.paddingMedium),
            Container(
              height: 300,
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
                boxShadow: const [AppTheme.softShadow],
              ),
              child: const Center(child: Text('Chart Placeholder')),
            ),
            const SizedBox(height: AppTheme.paddingXLarge),

            // Category Breakdown
            Text('By Category', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppTheme.paddingMedium),
            Container(
              height: 300,
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
                boxShadow: const [AppTheme.softShadow],
              ),
              child: const Center(child: Text('Chart Placeholder')),
            ),
          ],
        ),
      ),
    );
  }
}
