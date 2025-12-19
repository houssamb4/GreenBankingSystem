import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:greenpay/core/models/user.dart';
import 'package:greenpay/core/services/auth_service.dart';
import 'package:greenpay/core/services/token_storage_service.dart';
import 'package:greenpay/core/services/transaction_service.dart';
import 'package:greenpay/core/models/transaction.dart';
import 'package:greenpay/widgets/sidebar.dart';

class ProfileProvider extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;
  final TransactionService _transactionService = TransactionService.instance;
  final TokenStorageService _tokenStorage = TokenStorageService.instance;

  User? _currentUser;
  CarbonStats? _carbonStats;
  bool _isLoading = false;
  String? _error;

  User? get currentUser => _currentUser;
  CarbonStats? get carbonStats => _carbonStats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  String get userName => _currentUser?.fullName ?? 'User';
  String get userEmail => _currentUser?.email ?? '';
  String get userInitials {
    if (_currentUser == null) return 'U';
    final firstName = _currentUser!.firstName;
    final lastName = _currentUser!.lastName;
    return '${firstName.isNotEmpty ? firstName[0] : ''}${lastName.isNotEmpty ? lastName[0] : ''}'
        .toUpperCase();
  }

  Future<void> loadProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final userData = await _authService.getCurrentUser();
      if (userData != null) {
        _currentUser = User.fromJson(userData);
      }

      final userId = await _tokenStorage.getUserId();
      if (userId != null) {
        _carbonStats = await _transactionService.getCarbonStats(userId);
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateCarbonBudget(double budget) async {
    try {
      await _transactionService.updateCarbonBudget(budget);
      await loadProfile();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> logout(BuildContext context) async {
    await _authService.logout();
    if (context.mounted) {
      Navigator.of(context)
          .pushNamedAndRemoveUntil('/signIn', (route) => false);
    }
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late ProfileProvider _provider;
  bool _sidebarExpanded = true;

  @override
  void initState() {
    super.initState();
    _provider = ProfileProvider();
    _provider.loadProfile();
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
      child: Consumer<ProfileProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: AsanaColors.pageBg,
            body: Row(
              children: [
                AsanaSidebar(
                  currentRoute: '/profile',
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
                      _buildTopBar(provider),
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

  Widget _buildTopBar(ProfileProvider provider) {
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
            'Profile',
            style: TextStyle(
              color: AsanaColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () => Navigator.of(context).pushNamed('/settings'),
            icon:
                Icon(Icons.settings_outlined, color: AsanaColors.textSecondary),
            label: Text('Settings',
                style: TextStyle(color: AsanaColors.textSecondary)),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(ProfileProvider provider) {
    if (provider.isLoading) {
      return Center(
        child: CircularProgressIndicator(color: AsanaColors.green),
      );
    }

    return RefreshIndicator(
      onRefresh: provider.loadProfile,
      color: AsanaColors.green,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            _buildProfileHeader(provider),
            const SizedBox(height: 32),
            _buildStatsRow(provider),
            const SizedBox(height: 32),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    children: [
                      _buildAccountSettings(provider),
                      const SizedBox(height: 24),
                      _buildCarbonSettings(provider),
                    ],
                  ),
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      _buildAchievements(),
                      const SizedBox(height: 24),
                      _buildSecurityCard(provider),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ProfileProvider provider) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AsanaColors.green.withOpacity(0.1),
            AsanaColors.teal.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AsanaColors.green.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AsanaColors.purple, AsanaColors.pink],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: AsanaColors.purple.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Center(
              child: Text(
                provider.userInitials,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(width: 32),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.userName,
                  style: TextStyle(
                    color: AsanaColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  provider.userEmail,
                  style: TextStyle(
                    color: AsanaColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _buildProfileBadge(
                      icon: Icons.eco_rounded,
                      label: 'Eco Warrior',
                      color: AsanaColors.green,
                    ),
                    const SizedBox(width: 12),
                    _buildProfileBadge(
                      icon: Icons.star_rounded,
                      label:
                          'Score ${provider.carbonStats?.ecoScore.toStringAsFixed(0) ?? provider.currentUser?.ecoScore.toStringAsFixed(0) ?? "0"}',
                      color: AsanaColors.yellow,
                    ),
                  ],
                ),
              ],
            ),
          ),
          OutlinedButton.icon(
            onPressed: () {
              // TODO: Edit profile
            },
            icon: Icon(Icons.edit_outlined, size: 18, color: AsanaColors.green),
            label: Text('Edit Profile',
                style: TextStyle(color: AsanaColors.green)),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AsanaColors.green),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileBadge({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(ProfileProvider provider) {
    final stats = [
      (
        icon: Icons.eco_rounded,
        color: AsanaColors.green,
        title: 'Carbon Saved',
        value:
            '${provider.currentUser?.totalCarbonSaved.toStringAsFixed(1) ?? "0"} kg',
      ),
      (
        icon: Icons.bar_chart_rounded,
        color: AsanaColors.blue,
        title: 'Monthly Carbon',
        value:
            '${provider.carbonStats?.monthlyCarbon.toStringAsFixed(1) ?? "0"} kg',
      ),
      (
        icon: Icons.flag_rounded,
        color: AsanaColors.purple,
        title: 'Carbon Budget',
        value:
            '${provider.carbonStats?.carbonBudget.toStringAsFixed(0) ?? provider.currentUser?.monthlyCarbonBudget.toStringAsFixed(0) ?? "100"} kg',
      ),
      (
        icon: Icons.star_rounded,
        color: AsanaColors.yellow,
        title: 'Green Score',
        value:
            '${provider.carbonStats?.ecoScore.toStringAsFixed(0) ?? provider.currentUser?.ecoScore.toStringAsFixed(0) ?? "0"}/100',
      ),
    ];

    return Row(
      children: stats.map((stat) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              right: stats.indexOf(stat) < stats.length - 1 ? 16 : 0,
            ),
            child: _buildStatCard(
              icon: stat.icon,
              color: stat.color,
              title: stat.title,
              value: stat.value,
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required Color color,
    required String title,
    required String value,
  }) {
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
            value,
            style: TextStyle(
              color: AsanaColors.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              color: AsanaColors.textSecondary,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSettings(ProfileProvider provider) {
    final settings = [
      (
        icon: Icons.person_outline_rounded,
        title: 'Personal Information',
        subtitle: 'Name, email, phone number',
        onTap: () {},
      ),
      (
        icon: Icons.credit_card_rounded,
        title: 'Payment Methods',
        subtitle: 'Cards, bank accounts',
        onTap: () {},
      ),
      (
        icon: Icons.notifications_outlined,
        title: 'Notifications',
        subtitle: 'Carbon alerts, transaction updates',
        onTap: () {},
      ),
      (
        icon: Icons.language_rounded,
        title: 'Language & Region',
        subtitle: 'English (US)',
        onTap: () {},
      ),
    ];

    return _buildSettingsCard(
      title: 'Account Settings',
      children: settings.map((setting) {
        return _buildSettingsTile(
          icon: setting.icon,
          title: setting.title,
          subtitle: setting.subtitle,
          onTap: setting.onTap,
        );
      }).toList(),
    );
  }

  Widget _buildCarbonSettings(ProfileProvider provider) {
    return _buildSettingsCard(
      title: 'Carbon Settings',
      children: [
        _buildSettingsTileWithAction(
          icon: Icons.speed_rounded,
          title: 'Monthly Carbon Budget',
          subtitle:
              '${provider.carbonStats?.carbonBudget.toStringAsFixed(0) ?? provider.currentUser?.monthlyCarbonBudget.toStringAsFixed(0) ?? "100"} kg CO₂',
          action: TextButton(
            onPressed: () => _showBudgetDialog(context, provider),
            child: Text('Edit', style: TextStyle(color: AsanaColors.blue)),
          ),
        ),
        _buildSettingsTile(
          icon: Icons.notifications_active_outlined,
          title: 'Carbon Alerts',
          subtitle: 'Get notified at 75% and 100% of budget',
          onTap: () {},
        ),
        _buildSettingsTile(
          icon: Icons.lightbulb_outline_rounded,
          title: 'Personalized Tips',
          subtitle: 'Based on your spending patterns',
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildAchievements() {
    final achievements = [
      (
        icon: Icons.eco_rounded,
        title: 'First Green Purchase',
        color: AsanaColors.green
      ),
      (
        icon: Icons.directions_bus_rounded,
        title: 'Public Transport Pro',
        color: AsanaColors.blue
      ),
      (
        icon: Icons.local_florist_rounded,
        title: 'Carbon Saver',
        color: AsanaColors.teal
      ),
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
            'Achievements',
            style: TextStyle(
              color: AsanaColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: achievements.map((achievement) {
              return Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: achievement.color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: achievement.color.withOpacity(0.2)),
                ),
                child: Column(
                  children: [
                    Icon(achievement.icon, color: achievement.color, size: 28),
                    const SizedBox(height: 8),
                    Text(
                      achievement.title,
                      style: TextStyle(
                        color: achievement.color,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
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

  Widget _buildSecurityCard(ProfileProvider provider) {
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
            'Security',
            style: TextStyle(
              color: AsanaColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildSecurityItem(
            icon: Icons.lock_outline_rounded,
            title: 'Change Password',
            onTap: () {},
          ),
          _buildSecurityItem(
            icon: Icons.security_rounded,
            title: 'Two-Factor Auth',
            onTap: () {},
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => _showLogoutConfirmation(context, provider),
              icon: const Icon(Icons.logout_rounded),
              label: const Text('Log Out'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AsanaColors.red.withOpacity(0.1),
                foregroundColor: AsanaColors.red,
                elevation: 0,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsCard({
    required String title,
    required List<Widget> children,
  }) {
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
            title,
            style: TextStyle(
              color: AsanaColors.textPrimary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AsanaColors.pageBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: AsanaColors.textSecondary, size: 20),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        color: AsanaColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
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
              Icon(Icons.chevron_right_rounded, color: AsanaColors.textMuted),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTileWithAction({
    required IconData icon,
    required String title,
    required String subtitle,
    required Widget action,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AsanaColors.pageBg,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AsanaColors.textSecondary, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    color: AsanaColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
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
          action,
        ],
      ),
    );
  }

  Widget _buildSecurityItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Icon(icon, color: AsanaColors.textSecondary, size: 20),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  color: AsanaColors.textPrimary,
                  fontSize: 14,
                ),
              ),
              const Spacer(),
              Icon(Icons.chevron_right_rounded,
                  color: AsanaColors.textMuted, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  void _showBudgetDialog(BuildContext context, ProfileProvider provider) {
    final controller = TextEditingController(
      text: (provider.carbonStats?.carbonBudget ??
              provider.currentUser?.monthlyCarbonBudget ??
              100)
          .toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Update Carbon Budget'),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'Monthly Budget (kg CO₂)',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(color: AsanaColors.green, width: 2),
            ),
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
              final budget = double.tryParse(controller.text);
              if (budget != null && budget > 0) {
                await provider.updateCarbonBudget(budget);
                if (context.mounted) {
                  Navigator.pop(context);
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AsanaColors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(BuildContext context, ProfileProvider provider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AsanaColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              provider.logout(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AsanaColors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }
}
