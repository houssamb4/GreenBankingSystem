import 'package:flutter/material.dart';
import 'package:greenpay/core/theme/global_colors.dart';
import 'package:greenpay/widgets/app_drawer.dart';
import 'package:flareline_uikit/components/card/common_card.dart';

class EcommercePage extends StatelessWidget {
  const EcommercePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalColors.background,
      appBar: AppBar(
        title: const Text(
          'GreenPay Dashboard',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: GlobalColors.background,
        foregroundColor: GlobalColors.text,
        elevation: 0,
        actions: [
          // Notification icon
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_outlined),
                  onPressed: () {},
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: GlobalColors.danger,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      drawer: const AppDrawer(currentRoute: '/dashboard'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: const [
            InteractiveBanner(),
            SizedBox(height: 24),
            BalanceCardsSection(),
            SizedBox(height: 24),
            QuickActionsSection(),
            SizedBox(height: 24),
            CarbonTipsSection(),
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// Interactive welcome banner with eco icon
class InteractiveBanner extends StatelessWidget {
  const InteractiveBanner({super.key});

  @override
  Widget build(BuildContext context) {
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
}

/// Balance, Carbon Footprint, and Green Score cards
class BalanceCardsSection extends StatelessWidget {
  const BalanceCardsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool narrow = constraints.maxWidth < 900;

        if (narrow) {
          return const Column(
            children: [
              BalanceCard(),
              SizedBox(height: 16),
              CarbonFootprintCard(),
              SizedBox(height: 16),
              GreenScoreCard(),
            ],
          );
        }

        return const Row(
          children: [
            Expanded(child: BalanceCard()),
            SizedBox(width: 16),
            Expanded(child: CarbonFootprintCard()),
            SizedBox(width: 16),
            Expanded(child: GreenScoreCard()),
          ],
        );
      },
    );
  }
}

/// Balance card
class BalanceCard extends StatelessWidget {
  const BalanceCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Available Balance',
                style: TextStyle(
                  fontSize: 12,
                  color: GlobalColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.account_balance_wallet,
                color: GlobalColors.success,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '\$4,250.50',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: GlobalColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Ready to spend',
            style: TextStyle(
              fontSize: 12,
              color: GlobalColors.text.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Carbon Footprint card
class CarbonFootprintCard extends StatelessWidget {
  const CarbonFootprintCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Carbon Footprint',
                style: TextStyle(
                  fontSize: 12,
                  color: GlobalColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.eco,
                color: GlobalColors.danger,
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '42.5 kg CO₂',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: GlobalColors.text,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: 0.42,
              minHeight: 6,
              backgroundColor: GlobalColors.border,
              valueColor: const AlwaysStoppedAnimation<Color>(
                GlobalColors.warn,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'This month',
            style: TextStyle(
              fontSize: 12,
              color: GlobalColors.text.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}

/// Green Score card
class GreenScoreCard extends StatelessWidget {
  const GreenScoreCard({super.key});

  @override
  Widget build(BuildContext context) {
    return CommonCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Green Score',
                style: TextStyle(
                  fontSize: 12,
                  color: GlobalColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Icon(
                Icons.star,
                color: Color(0xFFFCD34D),
                size: 20,
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '78/100',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: GlobalColors.text,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Eco-friendly behavior',
              style: TextStyle(
                fontSize: 12,
                color: GlobalColors.success,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Quick action buttons section
class QuickActionsSection extends StatelessWidget {
  const QuickActionsSection({super.key});

  static const _actions = [
    (
      icon: Icons.paid,
      title: 'Send Money',
      subtitle: 'Low carbon transfer',
      color: Colors.blue,
      route: '/transactions',
    ),
    (
      icon: Icons.shopping_cart,
      title: 'Green Shopping',
      subtitle: 'Eco-friendly merchants',
      color: Colors.green,
      route: '/transactions',
    ),
    (
      icon: Icons.bar_chart,
      title: 'View Reports',
      subtitle: 'Carbon analytics',
      color: Colors.orange,
      route: '/impact',
    ),
    (
      icon: Icons.settings,
      title: 'Settings',
      subtitle: 'Manage preferences',
      color: Colors.purple,
      route: '/settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (int i = 0; i < _actions.length; i++) ...[
          Expanded(
            child: ActionCard(
              icon: _actions[i].icon,
              title: _actions[i].title,
              subtitle: _actions[i].subtitle,
              color: _actions[i].color,
              onTap: () => Navigator.of(context).pushNamed(_actions[i].route),
            ),
          ),
          if (i < _actions.length - 1) const SizedBox(width: 16),
        ]
      ],
    );
  }
}

/// Individual action card widget
class ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const ActionCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: CommonCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildIconContainer(),
              const SizedBox(height: 12),
              _buildTitle(),
              const SizedBox(height: 4),
              _buildSubtitle(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(icon, color: color, size: 24),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 12,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle() {
    return Text(
      subtitle,
      style: TextStyle(
        fontSize: 10,
        color: GlobalColors.text,
      ),
      textAlign: TextAlign.center,
    );
  }
}

/// Carbon reduction tips section
class CarbonTipsSection extends StatelessWidget {
  const CarbonTipsSection({super.key});

  static const _tips = [
    (
      title: 'Use Public Transport',
      description: 'Save 2.5 kg CO₂ per week',
      icon: Icons.directions_bus,
    ),
    (
      title: 'Shop Local',
      description: 'Reduce shipping emissions',
      icon: Icons.store,
    ),
    (
      title: 'Paperless Banking',
      description: 'Go digital, save trees',
      icon: Icons.description_outlined,
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
            children: [
              for (final tip in _tips)
                TipCard(
                  title: tip.title,
                  description: tip.description,
                  icon: tip.icon,
                )
            ],
          ),
        ],
      ),
    );
  }
}

/// Individual tip card
class TipCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const TipCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          _buildIconContainer(),
          const SizedBox(width: 16),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildIconContainer() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: GlobalColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(
        icon,
        color: GlobalColors.success,
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: TextStyle(
            fontSize: 12,
            color: GlobalColors.text,
          ),
        ),
      ],
    );
  }
}
