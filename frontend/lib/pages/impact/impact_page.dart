import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:greenpay/core/services/auth_service.dart';
import 'package:greenpay/core/services/transaction_service.dart';
import 'package:greenpay/core/services/token_storage_service.dart';
import 'package:greenpay/core/models/transaction.dart';
import 'package:greenpay/core/theme/asana_colors.dart';
import 'package:greenpay/widgets/sidebar.dart';

class ImpactProvider extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;
  final TransactionService _transactionService = TransactionService.instance;
  final TokenStorageService _tokenStorage = TokenStorageService.instance;

  Future<String?> _getUserId() async {
    return await _tokenStorage.getUserId();
  }

  bool _isLoading = true;
  String _userName = 'User';
  String _userEmail = '';
  String _userInitials = 'U';
  double _totalCarbon = 0;
  double _monthlyCarbon = 0;
  double _carbonBudget = 100;
  int _selectedMonth = DateTime.now().month;
  List<CategoryBreakdown> _categoryBreakdown = [];

  bool get isLoading => _isLoading;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userInitials => _userInitials;
  double get totalCarbon => _totalCarbon;
  double get monthlyCarbon => _monthlyCarbon;
  double get carbonBudget => _carbonBudget;
  int get selectedMonth => _selectedMonth;
  List<CategoryBreakdown> get categoryBreakdown => _categoryBreakdown;
  double get budgetUsedPercent =>
      (_monthlyCarbon / _carbonBudget * 100).clamp(0, 100);

  List<double> _monthlyData = List.filled(12, 0.0);
  List<double> get monthlyData => _monthlyData;

  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Load user data
      final userData = await _authService.getCurrentUser();
      if (userData != null) {
        _userName = '${userData['firstName']} ${userData['lastName']}';
        _userEmail = userData['email'] ?? '';
        final firstName = userData['firstName'] ?? '';
        final lastName = userData['lastName'] ?? '';
        _userInitials =
            '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
                .toUpperCase();
        _carbonBudget = (userData['monthlyCarbonBudget'] ?? 100).toDouble();
      }

      // Load carbon stats - need userId from token storage
      final userId = await _getUserId();
      if (userId != null) {
        final stats = await _transactionService.getCarbonStats(userId);
        if (stats != null) {
          _totalCarbon = stats.totalCarbon;
          _monthlyCarbon = stats.monthlyCarbon;
        }

        // Load category breakdown
        _categoryBreakdown =
            await _transactionService.getCategoryBreakdown(userId);

        // Load monthly historical data
        _monthlyData =
            await _transactionService.getMonthlyHistoricalCarbon(userId);
      }
    } catch (e) {
      // Ignore errors
    }

    _isLoading = false;
    notifyListeners();
  }

  void selectMonth(int month) {
    _selectedMonth = month;
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    await _authService.logout();
    if (context.mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/signIn', (route) => false);
    }
  }
}

class ImpactPage extends StatefulWidget {
  const ImpactPage({Key? key}) : super(key: key);

  @override
  State<ImpactPage> createState() => _ImpactPageState();
}

class _ImpactPageState extends State<ImpactPage> {
  late ImpactProvider _provider;
  bool _sidebarExpanded = true;

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

  @override
  void initState() {
    super.initState();
    _provider = ImpactProvider();
    _provider.loadData();
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
      child: Consumer<ImpactProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: AsanaColors.pageBg,
            body: Row(
              children: [
                AsanaSidebar(
                  currentRoute: '/impact',
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
                  child: Column(
                    children: [
                      _buildTopBar(),
                      Expanded(
                        child: provider.isLoading
                            ? Center(
                                child: CircularProgressIndicator(
                                  color: AsanaColors.green,
                                ),
                              )
                            : _buildContent(provider),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildTopBar() {
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
          Icon(Icons.eco_outlined, color: AsanaColors.green, size: 24),
          const SizedBox(width: 12),
          Text(
            'Carbon Impact',
            style: TextStyle(
              color: AsanaColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: AsanaColors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                Icon(Icons.trending_down, color: AsanaColors.green, size: 16),
                const SizedBox(width: 4),
                Text(
                  '12% vs last month',
                  style: TextStyle(
                    color: AsanaColors.green,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ImpactProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Your Environmental Impact',
            style: TextStyle(
              color: AsanaColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Track your carbon footprint and see how your spending affects the environment',
            style: TextStyle(
              color: AsanaColors.textSecondary,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 32),

          // Month Selector
          _buildMonthSelector(provider),
          const SizedBox(height: 32),

          // Stats Row
          Row(
            children: [
              Expanded(
                  child: _buildStatCard(
                'Total Carbon',
                '${provider.totalCarbon.toStringAsFixed(1)} kg',
                Icons.cloud_outlined,
                AsanaColors.blue,
                'All time emissions',
              )),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildStatCard(
                'Monthly Carbon',
                '${provider.monthlyCarbon.toStringAsFixed(1)} kg',
                Icons.calendar_today_outlined,
                AsanaColors.purple,
                'This month',
              )),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildStatCard(
                'Budget Used',
                '${provider.budgetUsedPercent.toStringAsFixed(0)}%',
                Icons.pie_chart_outline,
                provider.budgetUsedPercent > 80
                    ? AsanaColors.red
                    : AsanaColors.green,
                '${provider.carbonBudget.toStringAsFixed(0)} kg budget',
              )),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildStatCard(
                'Trees Equivalent',
                '${(provider.totalCarbon / 21).toStringAsFixed(1)}',
                Icons.park_outlined,
                AsanaColors.teal,
                'Trees needed to offset',
              )),
            ],
          ),
          const SizedBox(height: 32),

          // Charts Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: _buildMonthlyChart(provider),
              ),
              const SizedBox(width: 24),
              Expanded(
                child: _buildCategoryBreakdown(provider),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Impact Insights
          _buildInsightsSection(provider),
        ],
      ),
    );
  }

  Widget _buildMonthSelector(ImpactProvider provider) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AsanaColors.border),
      ),
      child: Row(
        children: List.generate(12, (index) {
          final isSelected = provider.selectedMonth == index + 1;
          return Expanded(
            child: GestureDetector(
              onTap: () => provider.selectMonth(index + 1),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: isSelected ? AsanaColors.green : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _months[index],
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color:
                        isSelected ? Colors.white : AsanaColors.textSecondary,
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AsanaColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: color, size: 20),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: TextStyle(
              color: AsanaColors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
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
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyChart(ImpactProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AsanaColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Monthly Emissions',
                style: TextStyle(
                  color: AsanaColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AsanaColors.pageBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '2024',
                  style: TextStyle(
                    color: AsanaColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            height: 250,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: List.generate(12, (index) {
                final value = provider.monthlyData[index];
                final maxValue =
                    provider.monthlyData.reduce((a, b) => a > b ? a : b);
                final height = (value / maxValue) * 160;
                final isSelected = provider.selectedMonth == index + 1;

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (isSelected)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            margin: const EdgeInsets.only(bottom: 8),
                            decoration: BoxDecoration(
                              color: AsanaColors.textPrimary,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${value.toStringAsFixed(1)} kg',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        else
                          const SizedBox(height: 24),
                        Container(
                          height: height,
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AsanaColors.green
                                : AsanaColors.green.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _months[index],
                          style: TextStyle(
                            color: isSelected
                                ? AsanaColors.textPrimary
                                : AsanaColors.textMuted,
                            fontSize: 11,
                            fontWeight:
                                isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryBreakdown(ImpactProvider provider) {
    final categories = provider.categoryBreakdown.isNotEmpty
        ? provider.categoryBreakdown
        : [
            CategoryBreakdown(
                category: 'Transport',
                totalCarbon: 25.5,
                totalAmount: 150.0,
                transactionCount: 5,
                percentage: 35),
            CategoryBreakdown(
                category: 'Food',
                totalCarbon: 18.2,
                totalAmount: 120.0,
                transactionCount: 8,
                percentage: 25),
            CategoryBreakdown(
                category: 'Shopping',
                totalCarbon: 14.6,
                totalAmount: 80.0,
                transactionCount: 3,
                percentage: 20),
            CategoryBreakdown(
                category: 'Travel',
                totalCarbon: 14.6,
                totalAmount: 200.0,
                transactionCount: 2,
                percentage: 20),
          ];

    final colors = [
      AsanaColors.green,
      AsanaColors.teal,
      AsanaColors.blue,
      AsanaColors.purple
    ];

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AsanaColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'By Category',
            style: TextStyle(
              color: AsanaColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 24),
          ...categories.asMap().entries.map((entry) {
            final index = entry.key;
            final cat = entry.value;
            final color = colors[index % colors.length];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cat.category,
                        style: TextStyle(
                          color: AsanaColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${cat.percentage.toStringAsFixed(0)}%',
                        style: TextStyle(
                          color: AsanaColors.textSecondary,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: cat.percentage / 100,
                    backgroundColor: AsanaColors.pageBg,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${cat.totalCarbon.toStringAsFixed(1)} kg CO₂',
                    style: TextStyle(
                      color: AsanaColors.textMuted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildInsightsSection(ImpactProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AsanaColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.lightbulb_outline,
                  color: AsanaColors.orange, size: 20),
              const SizedBox(width: 8),
              Text(
                'Impact Insights',
                style: TextStyle(
                  color: AsanaColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                  child: _buildInsightCard(
                'Transport Impact',
                'Your transport emissions are 15% higher than average. Consider carpooling or using public transit.',
                Icons.directions_car_outlined,
                AsanaColors.red,
              )),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildInsightCard(
                'Food Choices',
                'Great job! Your food-related carbon footprint is 20% lower than average users.',
                Icons.restaurant_outlined,
                AsanaColors.green,
              )),
              const SizedBox(width: 16),
              Expanded(
                  child: _buildInsightCard(
                'Shopping Habits',
                'Consider buying more second-hand items to reduce your shopping emissions by up to 30%.',
                Icons.shopping_bag_outlined,
                AsanaColors.orange,
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard(
      String title, String description, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              color: AsanaColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(
              color: AsanaColors.textSecondary,
              fontSize: 13,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
