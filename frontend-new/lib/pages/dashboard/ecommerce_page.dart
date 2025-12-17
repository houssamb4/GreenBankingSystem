import 'package:flutter/material.dart';
import 'package:greenpay/core/theme/global_colors.dart';
import 'package:greenpay/pages/dashboard/analytics_widget.dart';
import 'package:greenpay/pages/dashboard/channel_widget.dart';
import 'package:greenpay/pages/dashboard/grid_card.dart';
import 'package:greenpay/pages/dashboard/revenue_widget.dart';
import 'package:greenpay/pages/layout.dart';
import 'package:flareline_uikit/components/card/common_card.dart';

class EcommercePage extends LayoutWidget {
  const EcommercePage({super.key});

  @override
  String breakTabTitle(BuildContext context) {
    return 'Carbon Dashboard';
  }

  @override
  Widget contentDesktopWidget(BuildContext context) {
    return SingleChildScrollView(
      child: Column(children: [
        // Interactive Header Banner
        _buildInteractiveBanner(context),
        const SizedBox(height: 24),

        // Quick Action Buttons
        _buildQuickActions(context),
        const SizedBox(height: 24),

        GridCard(),
        const SizedBox(height: 16),

        RevenueWidget(),
        const SizedBox(height: 16),

        AnalyticsWidget(),
        const SizedBox(height: 16),

        ChannelWidget(),
        const SizedBox(height: 24),

        // Carbon Tips Section
        _buildCarbonTips(context),
        const SizedBox(height: 24),
      ]),
    );
  }

  Widget _buildInteractiveBanner(BuildContext context) {
    return CommonCard(
      padding: const EdgeInsets.all(24),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              GlobalColors.success.withOpacity(0.2),
              GlobalColors.secondary.withOpacity(0.1),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: GlobalColors.success.withOpacity(0.3),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Welcome to GreenPay',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Track your carbon footprint and make sustainable financial choices',
                    style: TextStyle(
                      fontSize: 14,
                      color: GlobalColors.text,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: GlobalColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.eco,
                color: GlobalColors.success,
                size: 32,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            icon: Icons.paid,
            title: 'Send Money',
            subtitle: 'Low carbon transfer',
            color: Colors.blue,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            icon: Icons.shopping_cart,
            title: 'Green Shopping',
            subtitle: 'Eco-friendly merchants',
            color: Colors.green,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            icon: Icons.bar_chart,
            title: 'View Reports',
            subtitle: 'Carbon analytics',
            color: Colors.orange,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            icon: Icons.settings,
            title: 'Settings',
            subtitle: 'Manage preferences',
            color: Colors.purple,
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: CommonCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 10,
                  color: GlobalColors.text,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCarbonTips(BuildContext context) {
    final tips = [
      {
        'title': 'Use Public Transport',
        'description': 'Save 2.5 kg COâ‚‚ per week',
        'icon': Icons.directions_bus,
      },
      {
        'title': 'Shop Local',
        'description': 'Reduce shipping emissions',
        'icon': Icons.store,
      },
      {
        'title': 'Paperless Banking',
        'description': 'Go digital, save trees',
        'icon': Icons.description_outlined,
      },
    ];

    return CommonCard(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Carbon Reduction Tips',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Column(
            children: tips.map((tip) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: GlobalColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        tip['icon'] as IconData,
                        color: GlobalColors.success,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            tip['title'] as String,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            tip['description'] as String,
                            style: TextStyle(
                              fontSize: 12,
                              color: GlobalColors.text,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
