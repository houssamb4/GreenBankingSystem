import 'package:flutter/material.dart';
import 'package:frontend/config/theme.dart';
import 'package:frontend/widgets/components.dart';

class AdviceScreen extends StatelessWidget {
  const AdviceScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final suggestions = [
      {
        'title': 'Reduce Restaurant Visits',
        'description':
            'You visit restaurants 3x per week. Cooking at home 2 times could save 2.5 kg CO₂/month',
        'impact': '2.5 kg',
        'icon': Icons.restaurant,
      },
      {
        'title': 'Use Public Transport',
        'description':
            'Your transport costs indicate frequent car usage. Try public transit 2 days/week',
        'impact': '5.2 kg',
        'icon': Icons.directions_bus,
      },
      {
        'title': 'Shop Local & Seasonal',
        'description':
            'Reduce imported goods by 30% to lower your food carbon footprint',
        'impact': '1.8 kg',
        'icon': Icons.local_offer,
      },
      {
        'title': 'Energy Efficiency',
        'description':
            'Switch to LED bulbs and smart thermostats to reduce utility emissions',
        'impact': '3.2 kg',
        'icon': Icons.bolt,
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Advice & Tips'),
        elevation: 1,
        shadowColor: AppTheme.borderLight,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingLarge),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'Personalized Recommendations',
              style: Theme.of(context).textTheme.displaySmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Based on your spending patterns, here are actions to reduce your carbon footprint',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.paddingXLarge),

            // Suggestions List
            Column(
              children: suggestions.asMap().entries.map((entry) {
                final index = entry.key;
                final suggestion = entry.value;
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: AppTheme.paddingMedium,
                  ),
                  child: _SuggestionCard(
                    title: suggestion['title'] as String,
                    description: suggestion['description'] as String,
                    impact: suggestion['impact'] as String,
                    icon: suggestion['icon'] as IconData,
                    onDone: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Great! Keep tracking your progress.'),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: AppTheme.paddingXLarge),

            // Challenges Section
            Text(
              'Monthly Challenges',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: AppTheme.paddingMedium),
            Container(
              padding: const EdgeInsets.all(AppTheme.paddingMedium),
              decoration: BoxDecoration(
                color: AppTheme.primaryDarkGreen.withOpacity(0.05),
                borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
                border: Border.all(color: AppTheme.primaryDarkGreen),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.emoji_events,
                        color: AppTheme.primaryDarkGreen,
                        size: 28,
                      ),
                      const SizedBox(width: AppTheme.paddingMedium),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Reduce 10% This Month',
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: AppTheme.primaryDarkGreen,
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                          Text(
                            'Current: 45.2 kg | Target: 40.7 kg',
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: AppTheme.paddingMedium),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: 0.35,
                      minHeight: 8,
                      backgroundColor: AppTheme.borderLight,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.primaryDarkGreen,
                      ),
                    ),
                  ),
                  const SizedBox(height: AppTheme.paddingMedium),
                  Text(
                    'You\'ve reduced 4.9 kg so far. Keep going!',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SuggestionCard extends StatefulWidget {
  final String title;
  final String description;
  final String impact;
  final IconData icon;
  final VoidCallback onDone;

  const _SuggestionCard({
    required this.title,
    required this.description,
    required this.impact,
    required this.icon,
    required this.onDone,
  });

  @override
  State<_SuggestionCard> createState() => _SuggestionCardState();
}

class _SuggestionCardState extends State<_SuggestionCard> {
  bool _isDone = false;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: _isDone ? 0.6 : 1.0,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.paddingMedium),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
          boxShadow: const [AppTheme.softShadow],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLightGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(
                      AppTheme.smallCornerRadius,
                    ),
                  ),
                  child: Icon(
                    widget.icon,
                    color: AppTheme.primaryDarkGreen,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppTheme.paddingMedium),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          decoration: _isDone
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Potential savings: ${widget.impact}',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppTheme.successGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Checkbox(
                  value: _isDone,
                  onChanged: (value) {
                    setState(() => _isDone = value ?? false);
                    if (_isDone) widget.onDone();
                  },
                  activeColor: AppTheme.primaryDarkGreen,
                ),
              ],
            ),
            const SizedBox(height: AppTheme.paddingMedium),
            Text(
              widget.description,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _isDone ? AppTheme.textLight : AppTheme.textMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
