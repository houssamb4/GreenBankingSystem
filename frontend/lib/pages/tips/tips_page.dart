import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:greenpay/core/services/auth_service.dart';
import 'package:greenpay/core/theme/asana_colors.dart';
import 'package:greenpay/widgets/sidebar.dart';

class TipsProvider extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;

  String _userName = 'User';
  String _userEmail = '';
  String _userInitials = 'U';
  String _selectedCategory = 'All';

  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userInitials => _userInitials;
  String get selectedCategory => _selectedCategory;

  final List<Map<String, dynamic>> tips = [
    {
      'icon': Icons.directions_bus,
      'title': 'Use Public Transport',
      'description':
          'Reduce your carbon footprint by 75% compared to driving alone. Public transit is more efficient and reduces traffic congestion.',
      'impact': 'Save ~5 kg CO₂/month',
      'category': 'Transport',
      'difficulty': 'Easy',
    },
    {
      'icon': Icons.local_grocery_store,
      'title': 'Shop Local',
      'description':
          'Buy from local merchants to reduce transportation emissions. Local products travel shorter distances and support your community.',
      'impact': 'Save ~2.5 kg CO₂/month',
      'category': 'Shopping',
      'difficulty': 'Easy',
    },
    {
      'icon': Icons.description,
      'title': 'Go Paperless',
      'description':
          'Switch to digital statements and receipts to save trees and resources. Enable paperless billing for all your accounts.',
      'impact': 'Save ~0.5 kg CO₂/month',
      'category': 'Lifestyle',
      'difficulty': 'Easy',
    },
    {
      'icon': Icons.energy_savings_leaf,
      'title': 'Choose Organic',
      'description':
          'Organic products require less energy and chemicals to produce. They also support sustainable farming practices.',
      'impact': 'Save ~3 kg CO₂/month',
      'category': 'Food',
      'difficulty': 'Medium',
    },
    {
      'icon': Icons.ev_station,
      'title': 'Switch to Electric Vehicle',
      'description':
          'Electric vehicles produce 50% less emissions over their lifetime. Consider hybrid options as a transition step.',
      'impact': 'Save ~15 kg CO₂/month',
      'category': 'Transport',
      'difficulty': 'Hard',
    },
    {
      'icon': Icons.home,
      'title': 'Energy-Efficient Home',
      'description':
          'Use LED lights, insulate properly, and optimize heating/cooling. Smart thermostats can reduce energy waste significantly.',
      'impact': 'Save ~8 kg CO₂/month',
      'category': 'Lifestyle',
      'difficulty': 'Medium',
    },
    {
      'icon': Icons.shopping_bag,
      'title': 'Buy Second-Hand',
      'description':
          'Reduce manufacturing emissions by purchasing pre-owned items. Thrift stores and online marketplaces offer great options.',
      'impact': 'Save ~4 kg CO₂/month',
      'category': 'Shopping',
      'difficulty': 'Easy',
    },
    {
      'icon': Icons.water_drop,
      'title': 'Conserve Water',
      'description':
          'Shorter showers and fixing leaks reduce water treatment emissions. Install low-flow fixtures for easy savings.',
      'impact': 'Save ~1.5 kg CO₂/month',
      'category': 'Lifestyle',
      'difficulty': 'Easy',
    },
    {
      'icon': Icons.restaurant,
      'title': 'Reduce Meat Consumption',
      'description':
          'Try Meatless Mondays or switch to plant-based alternatives. Livestock farming is a major source of greenhouse gases.',
      'impact': 'Save ~10 kg CO₂/month',
      'category': 'Food',
      'difficulty': 'Medium',
    },
    {
      'icon': Icons.flight_takeoff,
      'title': 'Choose Direct Flights',
      'description':
          'When flying, choose direct routes. Takeoffs and landings produce the most emissions during air travel.',
      'impact': 'Save ~20 kg CO₂/trip',
      'category': 'Transport',
      'difficulty': 'Easy',
    },
    {
      'icon': Icons.recycling,
      'title': 'Recycle Properly',
      'description':
          'Learn your local recycling rules and follow them. Contaminated recyclables often end up in landfills.',
      'impact': 'Save ~2 kg CO₂/month',
      'category': 'Lifestyle',
      'difficulty': 'Easy',
    },
    {
      'icon': Icons.compost,
      'title': 'Start Composting',
      'description':
          'Compost food scraps to reduce methane from landfills. Use the compost for gardening or donate to community gardens.',
      'impact': 'Save ~3 kg CO₂/month',
      'category': 'Food',
      'difficulty': 'Medium',
    },
  ];

  List<String> get categories =>
      ['All', 'Transport', 'Food', 'Shopping', 'Lifestyle'];

  List<Map<String, dynamic>> get filteredTips {
    if (_selectedCategory == 'All') return tips;
    return tips.where((tip) => tip['category'] == _selectedCategory).toList();
  }

  Future<void> loadData() async {
    try {
      final userData = await _authService.getCurrentUser();
      if (userData != null) {
        _userName = '${userData['firstName']} ${userData['lastName']}';
        _userEmail = userData['email'] ?? '';
        final firstName = userData['firstName'] ?? '';
        final lastName = userData['lastName'] ?? '';
        _userInitials =
            '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
                .toUpperCase();
      }
      notifyListeners();
    } catch (e) {
      // Ignore errors
    }
  }

  void selectCategory(String category) {
    _selectedCategory = category;
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

class TipsPage extends StatefulWidget {
  const TipsPage({Key? key}) : super(key: key);

  @override
  State<TipsPage> createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  late TipsProvider _provider;
  bool _sidebarExpanded = true;

  @override
  void initState() {
    super.initState();
    _provider = TipsProvider();
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
      child: Consumer<TipsProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: AsanaColors.pageBg,
            body: Row(
              children: [
                AsanaSidebar(
                  currentRoute: '/tips',
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
                        child: _buildContent(provider),
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
          Icon(Icons.lightbulb_outline, color: AsanaColors.orange, size: 24),
          const SizedBox(width: 12),
          Text(
            'Green Tips',
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
                Icon(Icons.eco, color: AsanaColors.green, size: 16),
                const SizedBox(width: 4),
                Text(
                  '12 tips available',
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

  Widget _buildContent(TipsProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sustainable Living Tips',
                      style: TextStyle(
                        color: AsanaColors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Practical ways to reduce your carbon footprint and live more sustainably',
                      style: TextStyle(
                        color: AsanaColors.textSecondary,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              ),
              _buildPotentialSavings(),
            ],
          ),
          const SizedBox(height: 32),

          // Category Filter
          _buildCategoryFilter(provider),
          const SizedBox(height: 32),

          // Tips Grid
          _buildTipsGrid(provider),
        ],
      ),
    );
  }

  Widget _buildPotentialSavings() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AsanaColors.green, AsanaColors.teal],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.savings_outlined, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Potential Savings',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '~74 kg CO₂/month',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'If you follow all tips',
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter(TipsProvider provider) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AsanaColors.border),
      ),
      child: Row(
        children: provider.categories.map((category) {
          final isSelected = provider.selectedCategory == category;
          final icon = _getCategoryIcon(category);
          return Expanded(
            child: GestureDetector(
              onTap: () => provider.selectCategory(category),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected ? AsanaColors.green : Colors.transparent,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      icon,
                      size: 16,
                      color:
                          isSelected ? Colors.white : AsanaColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      category,
                      style: TextStyle(
                        color: isSelected
                            ? Colors.white
                            : AsanaColors.textSecondary,
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Transport':
        return Icons.directions_car_outlined;
      case 'Food':
        return Icons.restaurant_outlined;
      case 'Shopping':
        return Icons.shopping_bag_outlined;
      case 'Lifestyle':
        return Icons.home_outlined;
      default:
        return Icons.apps_outlined;
    }
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty) {
      case 'Easy':
        return AsanaColors.green;
      case 'Medium':
        return AsanaColors.orange;
      case 'Hard':
        return AsanaColors.red;
      default:
        return AsanaColors.textMuted;
    }
  }

  Widget _buildTipsGrid(TipsProvider provider) {
    final tips = provider.filteredTips;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
        childAspectRatio: 1.1,
      ),
      itemCount: tips.length,
      itemBuilder: (context, index) {
        final tip = tips[index];
        return _buildTipCard(tip);
      },
    );
  }

  Widget _buildTipCard(Map<String, dynamic> tip) {
    final difficultyColor = _getDifficultyColor(tip['difficulty']);

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
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AsanaColors.green.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  tip['icon'] as IconData,
                  color: AsanaColors.green,
                  size: 22,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: difficultyColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  tip['difficulty'],
                  style: TextStyle(
                    color: difficultyColor,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            tip['title'],
            style: TextStyle(
              color: AsanaColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Text(
              tip['description'],
              style: TextStyle(
                color: AsanaColors.textSecondary,
                fontSize: 13,
                height: 1.5,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: AsanaColors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.eco, color: AsanaColors.green, size: 14),
                const SizedBox(width: 6),
                Text(
                  tip['impact'],
                  style: TextStyle(
                    color: AsanaColors.green,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
