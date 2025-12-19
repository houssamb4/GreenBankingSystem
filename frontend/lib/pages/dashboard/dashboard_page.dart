import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:greenpay/pages/dashboard/dashboard_provider.dart';
import 'package:greenpay/widgets/sidebar.dart';
import 'package:greenpay/core/models/transaction.dart';
import 'package:intl/intl.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late DashboardProvider _provider;
  bool _sidebarExpanded = true;

  @override
  void initState() {
    super.initState();
    _provider = DashboardProvider();
    _provider.loadDashboardData();
  }

  @override
  void dispose() {
    _provider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _provider,
      child: Consumer<DashboardProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: AsanaColors.pageBg,
            body: Row(
              children: [
                AsanaSidebar(
                  currentRoute: '/dashboard',
                  userName: provider.userName,
                  userEmail: provider.userEmail,
                  userInitials: provider.userInitials,
                  isExpanded: _sidebarExpanded,
                  onExpandedChanged: (expanded) {
                    setState(() {
                      _sidebarExpanded = expanded;
                    });
                  },
                  onLogout: () => provider.logout(context),
                ),
                Expanded(
                  child: _buildMainContent(provider),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMainContent(DashboardProvider provider) {
    return Column(
      children: [
        _buildTopBar(provider),
        Expanded(
          child: provider.isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    color: AsanaColors.green,
                  ),
                )
              : RefreshIndicator(
                  onRefresh: provider.refreshData,
                  color: AsanaColors.green,
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildWelcomeSection(provider),
                        const SizedBox(height: 32),
                        _buildStatsCards(provider),
                        const SizedBox(height: 32),
                        _buildMainGrid(provider),
                      ],
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildTopBar(DashboardProvider provider) {
    return Container(
      height: 64,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AsanaColors.border),
        ),
      ),
      child: Row(
        children: [
          Text(
            'Home',
            style: TextStyle(
              color: AsanaColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AsanaColors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.eco_rounded, size: 16, color: AsanaColors.green),
                const SizedBox(width: 6),
                Text(
                  'Eco Score: ${provider.ecoScore.toStringAsFixed(0)}',
                  style: TextStyle(
                    color: AsanaColors.green,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          _buildTopBarButton(Icons.add, 'Create', AsanaColors.green, () {
            _showCreateTransactionDialog(context, provider);
          }),
          const SizedBox(width: 12),
          IconButton(
            icon: Icon(Icons.notifications_outlined,
                color: AsanaColors.textSecondary),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.help_outline, color: AsanaColors.textSecondary),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildTopBarButton(
      IconData icon, String label, Color color, VoidCallback onTap) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(8),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(DashboardProvider provider) {
    final hour = DateTime.now().hour;
    String greeting;
    if (hour < 12) {
      greeting = 'Good morning';
    } else if (hour < 17) {
      greeting = 'Good afternoon';
    } else {
      greeting = 'Good evening';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$greeting, ${provider.currentUser?.firstName ?? 'there'}!',
          style: TextStyle(
            color: AsanaColors.textPrimary,
            fontSize: 28,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          DateFormat('EEEE, MMMM d').format(DateTime.now()),
          style: TextStyle(
            color: AsanaColors.textSecondary,
            fontSize: 16,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsCards(DashboardProvider provider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;

        final cards = [
          _StatCard(
            icon: Icons.account_balance_wallet_rounded,
            iconColor: AsanaColors.green,
            title: 'Available Balance',
            value: '\$4,250.50',
            subtitle: 'Ready to spend',
            trend: '+12.5%',
            trendUp: true,
          ),
          _StatCard(
            icon: Icons.eco_rounded,
            iconColor: AsanaColors.teal,
            title: 'Monthly Carbon',
            value: '${provider.monthlyCarbon.toStringAsFixed(1)} kg',
            subtitle:
                '${(provider.carbonPercentage * 100).toStringAsFixed(0)}% of budget',
            progress: provider.carbonPercentage.clamp(0.0, 1.0),
            progressColor: _getCarbonColor(provider.carbonPercentage),
          ),
          _StatCard(
            icon: Icons.savings_rounded,
            iconColor: AsanaColors.purple,
            title: 'Carbon Saved',
            value: '${provider.totalCarbonSaved.toStringAsFixed(1)} kg',
            subtitle: 'This month',
            trend: '+8.2%',
            trendUp: true,
          ),
          _StatCard(
            icon: Icons.star_rounded,
            iconColor: AsanaColors.yellow,
            title: 'Green Score',
            value: '${provider.ecoScore.toStringAsFixed(0)}/100',
            subtitle: _getScoreLabel(provider.ecoScore),
            progress: provider.ecoScore / 100,
            progressColor: AsanaColors.yellow,
          ),
        ];

        if (isWide) {
          return Row(
            children: cards.map((card) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: cards.indexOf(card) < cards.length - 1 ? 16 : 0,
                  ),
                  child: _buildStatCardWidget(card),
                ),
              );
            }).toList(),
          );
        }

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: cards.map((card) {
            return SizedBox(
              width: (constraints.maxWidth - 16) / 2,
              child: _buildStatCardWidget(card),
            );
          }).toList(),
        );
      },
    );
  }

  Color _getCarbonColor(double percentage) {
    if (percentage <= 0.5) return AsanaColors.green;
    if (percentage <= 0.75) return AsanaColors.yellow;
    if (percentage <= 1.0) return AsanaColors.orange;
    return AsanaColors.red;
  }

  String _getScoreLabel(double score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Good';
    if (score >= 40) return 'Fair';
    return 'Needs improvement';
  }

  Widget _buildStatCardWidget(_StatCard card) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AsanaColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: card.iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(card.icon, color: card.iconColor, size: 22),
              ),
              if (card.trend != null)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: (card.trendUp ? AsanaColors.green : AsanaColors.red)
                        .withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        card.trendUp ? Icons.trending_up : Icons.trending_down,
                        color:
                            card.trendUp ? AsanaColors.green : AsanaColors.red,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        card.trend!,
                        style: TextStyle(
                          color: card.trendUp
                              ? AsanaColors.green
                              : AsanaColors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            card.title,
            style: TextStyle(
              color: AsanaColors.textSecondary,
              fontSize: 13,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            card.value,
            style: TextStyle(
              color: AsanaColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          if (card.progress != null) ...[
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: card.progress!,
                backgroundColor: AsanaColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(
                    card.progressColor ?? AsanaColors.green),
                minHeight: 6,
              ),
            ),
            const SizedBox(height: 8),
          ],
          Text(
            card.subtitle,
            style: TextStyle(
              color: AsanaColors.textMuted,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainGrid(DashboardProvider provider) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 1000;

        if (isWide) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildRecentTransactions(provider),
                    const SizedBox(height: 24),
                    _buildQuickActions(provider),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildCarbonBreakdown(provider),
                    const SizedBox(height: 24),
                    _buildGreenTips(),
                  ],
                ),
              ),
            ],
          );
        }

        return Column(
          children: [
            _buildRecentTransactions(provider),
            const SizedBox(height: 24),
            _buildCarbonBreakdown(provider),
            const SizedBox(height: 24),
            _buildQuickActions(provider),
            const SizedBox(height: 24),
            _buildGreenTips(),
          ],
        );
      },
    );
  }

  Widget _buildRecentTransactions(DashboardProvider provider) {
    return _buildCard(
      title: 'Recent Transactions',
      action: TextButton.icon(
        onPressed: () => Navigator.of(context).pushNamed('/transactions'),
        icon: const Text('View all'),
        label: Icon(Icons.arrow_forward, size: 16, color: AsanaColors.blue),
        style: TextButton.styleFrom(
          foregroundColor: AsanaColors.blue,
        ),
      ),
      child: provider.transactions.isEmpty
          ? _buildEmptyState(
              icon: Icons.receipt_long_outlined,
              title: 'No transactions yet',
              subtitle: 'Your transactions will appear here',
            )
          : Column(
              children: provider.recentTransactions.map((transaction) {
                return _buildTransactionTile(transaction);
              }).toList(),
            ),
    );
  }

  Widget _buildTransactionTile(Transaction transaction) {
    final categoryIcons = {
      'FOOD': Icons.restaurant_rounded,
      'TRANSPORT': Icons.directions_car_rounded,
      'SHOPPING': Icons.shopping_bag_rounded,
      'ENERGY': Icons.bolt_rounded,
      'TRAVEL': Icons.flight_rounded,
      'ENTERTAINMENT': Icons.movie_rounded,
      'GREEN': Icons.eco_rounded,
    };

    final categoryColors = {
      'FOOD': AsanaColors.orange,
      'TRANSPORT': AsanaColors.blue,
      'SHOPPING': AsanaColors.purple,
      'ENERGY': AsanaColors.yellow,
      'TRAVEL': AsanaColors.pink,
      'ENTERTAINMENT': AsanaColors.teal,
      'GREEN': AsanaColors.green,
    };

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (categoryColors[transaction.category] ??
                      AsanaColors.textSecondary)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              categoryIcons[transaction.category] ?? Icons.payment_rounded,
              color: categoryColors[transaction.category] ??
                  AsanaColors.textSecondary,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction.merchant,
                  style: TextStyle(
                    color: AsanaColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  DateFormat('MMM d, yyyy').format(transaction.transactionDate),
                  style: TextStyle(
                    color: AsanaColors.textMuted,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '-\$${transaction.amount.toStringAsFixed(2)}',
                style: TextStyle(
                  color: AsanaColors.textPrimary,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '+${transaction.carbonFootprint.toStringAsFixed(1)} kg CO₂',
                style: TextStyle(
                  color:
                      _getTransactionCarbonColor(transaction.carbonFootprint),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getTransactionCarbonColor(double carbon) {
    if (carbon <= 1) return AsanaColors.green;
    if (carbon <= 5) return AsanaColors.yellow;
    if (carbon <= 20) return AsanaColors.orange;
    return AsanaColors.red;
  }

  Widget _buildCarbonBreakdown(DashboardProvider provider) {
    return _buildCard(
      title: 'Carbon by Category',
      child: provider.categoryBreakdown.isEmpty
          ? _buildEmptyState(
              icon: Icons.pie_chart_outline,
              title: 'No data yet',
              subtitle: 'Make transactions to see your carbon breakdown',
            )
          : Column(
              children: provider.categoryBreakdown.take(5).map((category) {
                return _buildCategoryRow(category);
              }).toList(),
            ),
    );
  }

  Widget _buildCategoryRow(CategoryBreakdown category) {
    final categoryColors = {
      'FOOD': AsanaColors.orange,
      'TRANSPORT': AsanaColors.blue,
      'SHOPPING': AsanaColors.purple,
      'ENERGY': AsanaColors.yellow,
      'TRAVEL': AsanaColors.pink,
      'ENTERTAINMENT': AsanaColors.teal,
      'GREEN': AsanaColors.green,
    };

    final color =
        categoryColors[category.category] ?? AsanaColors.textSecondary;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              category.category.toLowerCase().replaceFirst(
                    category.category[0].toLowerCase(),
                    category.category[0].toUpperCase(),
                  ),
              style: TextStyle(
                color: AsanaColors.textPrimary,
                fontSize: 14,
              ),
            ),
          ),
          Text(
            '${category.totalCarbon.toStringAsFixed(1)} kg',
            style: TextStyle(
              color: AsanaColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: category.percentage / 100,
                backgroundColor: AsanaColors.border,
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(DashboardProvider provider) {
    final actions = [
      (
        icon: Icons.send_rounded,
        title: 'Send Money',
        subtitle: 'Low carbon transfer',
        color: AsanaColors.blue,
        onTap: () {},
      ),
      (
        icon: Icons.store_rounded,
        title: 'Green Shopping',
        subtitle: 'Eco merchants',
        color: AsanaColors.green,
        onTap: () {},
      ),
      (
        icon: Icons.bar_chart_rounded,
        title: 'View Reports',
        subtitle: 'Analytics',
        color: AsanaColors.purple,
        onTap: () => Navigator.of(context).pushNamed('/impact'),
      ),
      (
        icon: Icons.settings_rounded,
        title: 'Settings',
        subtitle: 'Preferences',
        color: AsanaColors.textSecondary,
        onTap: () => Navigator.of(context).pushNamed('/settings'),
      ),
    ];

    return _buildCard(
      title: 'Quick Actions',
      child: GridView.count(
        crossAxisCount: 4,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.2,
        children: actions.map((action) {
          return _buildQuickActionTile(
            icon: action.icon,
            title: action.title,
            subtitle: action.subtitle,
            color: action.color,
            onTap: action.onTap,
          );
        }).toList(),
      ),
    );
  }

  Widget _buildQuickActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        hoverColor: AsanaColors.hoverBg,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            border: Border.all(color: AsanaColors.border),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              const SizedBox(height: 10),
              Text(
                title,
                style: TextStyle(
                  color: AsanaColors.textPrimary,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreenTips() {
    final tips = [
      (
        icon: Icons.directions_bus_rounded,
        title: 'Use Public Transport',
        description: 'Save 2.5 kg CO₂/week',
      ),
      (
        icon: Icons.store_rounded,
        title: 'Shop Local',
        description: 'Reduce shipping emissions',
      ),
      (
        icon: Icons.phone_android_rounded,
        title: 'Go Paperless',
        description: 'Digital statements',
      ),
    ];

    return _buildCard(
      title: 'Green Tips',
      action: TextButton(
        onPressed: () => Navigator.of(context).pushNamed('/tips'),
        child: Text('See all', style: TextStyle(color: AsanaColors.blue)),
      ),
      child: Column(
        children: tips.map((tip) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AsanaColors.green.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(tip.icon, color: AsanaColors.green, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tip.title,
                        style: TextStyle(
                          color: AsanaColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        tip.description,
                        style: TextStyle(
                          color: AsanaColors.textMuted,
                          fontSize: 12,
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
    );
  }

  Widget _buildCard({
    required String title,
    Widget? action,
    required Widget child,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AsanaColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: AsanaColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (action != null) action,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Center(
        child: Column(
          children: [
            Icon(icon, size: 48, color: AsanaColors.textMuted),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                color: AsanaColors.textSecondary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: AsanaColors.textMuted,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateTransactionDialog(
      BuildContext context, DashboardProvider provider) {
    final amountController = TextEditingController();
    final merchantController = TextEditingController();
    final descriptionController = TextEditingController();
    String selectedCategory = 'FOOD';

    final categories = [
      'FOOD',
      'TRANSPORT',
      'SHOPPING',
      'ENERGY',
      'SERVICES',
      'ENTERTAINMENT',
      'TRAVEL',
      'HEALTHCARE',
      'EDUCATION',
      'TECHNOLOGY',
      'FASHION',
      'HOME',
      'GREEN',
      'OTHER',
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.add_circle_outline, color: AsanaColors.green),
            const SizedBox(width: 12),
            const Text('New Transaction'),
          ],
        ),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount',
                  prefixText: '\$ ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: merchantController,
                decoration: InputDecoration(
                  labelText: 'Merchant',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                items: categories.map((cat) {
                  return DropdownMenuItem(value: cat, child: Text(cat));
                }).toList(),
                onChanged: (value) {
                  selectedCategory = value ?? 'FOOD';
                },
              ),
              const SizedBox(height: 16),
              TextField(
                controller: descriptionController,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AsanaColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () async {
              final amount = double.tryParse(amountController.text);
              if (amount != null && merchantController.text.isNotEmpty) {
                await provider.createTransaction(
                  amount: amount,
                  category: selectedCategory,
                  merchant: merchantController.text,
                  description: descriptionController.text.isNotEmpty
                      ? descriptionController.text
                      : null,
                );
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AsanaColors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Create'),
          ),
        ],
      ),
    );
  }
}

class _StatCard {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String subtitle;
  final String? trend;
  final bool trendUp;
  final double? progress;
  final Color? progressColor;

  _StatCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.subtitle,
    this.trend,
    this.trendUp = true,
    this.progress,
    this.progressColor,
  });
}
