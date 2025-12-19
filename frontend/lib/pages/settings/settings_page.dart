import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:greenpay/core/services/auth_service.dart';
import 'package:greenpay/core/services/token_storage_service.dart';
import 'package:greenpay/widgets/asana_sidebar.dart';

class SettingsProvider extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;
  final TokenStorageService _tokenStorage = TokenStorageService.instance;

  bool _darkMode = false;
  bool _carbonAlerts = true;
  bool _transactionNotifications = true;
  bool _weeklyReports = true;
  String _language = 'English';
  String _currency = 'USD';
  String _userName = 'User';
  String _userEmail = '';
  String _userInitials = 'U';

  bool get darkMode => _darkMode;
  bool get carbonAlerts => _carbonAlerts;
  bool get transactionNotifications => _transactionNotifications;
  bool get weeklyReports => _weeklyReports;
  String get language => _language;
  String get currency => _currency;
  String get userName => _userName;
  String get userEmail => _userEmail;
  String get userInitials => _userInitials;

  Future<void> loadSettings() async {
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

  void toggleDarkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  void toggleCarbonAlerts(bool value) {
    _carbonAlerts = value;
    notifyListeners();
  }

  void toggleTransactionNotifications(bool value) {
    _transactionNotifications = value;
    notifyListeners();
  }

  void toggleWeeklyReports(bool value) {
    _weeklyReports = value;
    notifyListeners();
  }

  void setLanguage(String value) {
    _language = value;
    notifyListeners();
  }

  void setCurrency(String value) {
    _currency = value;
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

class AsanaSettingsPage extends StatefulWidget {
  const AsanaSettingsPage({Key? key}) : super(key: key);

  @override
  State<AsanaSettingsPage> createState() => _AsanaSettingsPageState();
}

class _AsanaSettingsPageState extends State<AsanaSettingsPage> {
  late SettingsProvider _provider;
  bool _sidebarExpanded = true;

  @override
  void initState() {
    super.initState();
    _provider = SettingsProvider();
    _provider.loadSettings();
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
      child: Consumer<SettingsProvider>(
        builder: (context, provider, child) {
          return Scaffold(
            backgroundColor: AsanaColors.pageBg,
            body: Row(
              children: [
                AsanaSidebar(
                  currentRoute: '/settings',
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
          Text(
            'Settings',
            style: TextStyle(
              color: AsanaColors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Icon(Icons.settings_outlined, color: AsanaColors.textMuted),
        ],
      ),
    );
  }

  Widget _buildContent(SettingsProvider provider) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Page title
          Text(
            'Preferences',
            style: TextStyle(
              color: AsanaColors.textPrimary,
              fontSize: 24,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Manage your account settings and preferences',
            style: TextStyle(
              color: AsanaColors.textSecondary,
              fontSize: 15,
            ),
          ),
          const SizedBox(height: 32),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  children: [
                    _buildNotificationsCard(provider),
                    const SizedBox(height: 24),
                    _buildAppearanceCard(provider),
                    const SizedBox(height: 24),
                    _buildDataCard(),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    _buildRegionalCard(provider),
                    const SizedBox(height: 24),
                    _buildAboutCard(),
                    const SizedBox(height: 24),
                    _buildDangerZone(provider),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsCard(SettingsProvider provider) {
    return _buildCard(
      title: 'Notifications',
      icon: Icons.notifications_outlined,
      children: [
        _buildToggleRow(
          title: 'Carbon Alerts',
          subtitle: 'Get notified when you reach carbon budget thresholds',
          value: provider.carbonAlerts,
          onChanged: provider.toggleCarbonAlerts,
        ),
        Divider(color: AsanaColors.border),
        _buildToggleRow(
          title: 'Transaction Notifications',
          subtitle: 'Receive alerts for new transactions',
          value: provider.transactionNotifications,
          onChanged: provider.toggleTransactionNotifications,
        ),
        Divider(color: AsanaColors.border),
        _buildToggleRow(
          title: 'Weekly Reports',
          subtitle: 'Get weekly carbon impact summaries',
          value: provider.weeklyReports,
          onChanged: provider.toggleWeeklyReports,
        ),
      ],
    );
  }

  Widget _buildAppearanceCard(SettingsProvider provider) {
    return _buildCard(
      title: 'Appearance',
      icon: Icons.palette_outlined,
      children: [
        _buildToggleRow(
          title: 'Dark Mode',
          subtitle: 'Use dark theme for better visibility at night',
          value: provider.darkMode,
          onChanged: provider.toggleDarkMode,
        ),
      ],
    );
  }

  Widget _buildDataCard() {
    return _buildCard(
      title: 'Data & Export',
      icon: Icons.download_outlined,
      children: [
        _buildActionRow(
          title: 'Export Carbon Report',
          subtitle: 'Download your monthly report as PDF',
          icon: Icons.picture_as_pdf_outlined,
          onTap: () => _showExportDialog('Carbon Report'),
        ),
        Divider(color: AsanaColors.border),
        _buildActionRow(
          title: 'Export Transactions',
          subtitle: 'Download all transactions as CSV',
          icon: Icons.table_chart_outlined,
          onTap: () => _showExportDialog('Transactions'),
        ),
        Divider(color: AsanaColors.border),
        _buildActionRow(
          title: 'Clear Cache',
          subtitle: 'Remove cached data (15.2 MB)',
          icon: Icons.delete_outline,
          onTap: () => _showClearCacheDialog(),
        ),
      ],
    );
  }

  Widget _buildRegionalCard(SettingsProvider provider) {
    return _buildCard(
      title: 'Regional',
      icon: Icons.language_outlined,
      children: [
        _buildSelectRow(
          title: 'Language',
          value: provider.language,
          options: ['English', 'Spanish', 'French', 'German', 'Japanese'],
          onSelected: provider.setLanguage,
        ),
        Divider(color: AsanaColors.border),
        _buildSelectRow(
          title: 'Currency',
          value: provider.currency,
          options: ['USD', 'EUR', 'GBP', 'JPY', 'CAD'],
          onSelected: provider.setCurrency,
        ),
      ],
    );
  }

  Widget _buildAboutCard() {
    return _buildCard(
      title: 'About',
      icon: Icons.info_outline,
      children: [
        _buildInfoRow('App Version', '1.0.0'),
        Divider(color: AsanaColors.border),
        _buildActionRow(
          title: 'Terms of Service',
          icon: Icons.description_outlined,
          onTap: () {},
        ),
        Divider(color: AsanaColors.border),
        _buildActionRow(
          title: 'Privacy Policy',
          icon: Icons.privacy_tip_outlined,
          onTap: () {},
        ),
        Divider(color: AsanaColors.border),
        _buildActionRow(
          title: 'Help & Support',
          icon: Icons.help_outline,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildDangerZone(SettingsProvider provider) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AsanaColors.red.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded,
                  color: AsanaColors.red, size: 20),
              const SizedBox(width: 8),
              Text(
                'Danger Zone',
                style: TextStyle(
                  color: AsanaColors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _showLogoutConfirmation(provider),
              style: OutlinedButton.styleFrom(
                foregroundColor: AsanaColors.red,
                side: BorderSide(color: AsanaColors.red),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Log Out'),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () => _showDeleteAccountDialog(),
              style: OutlinedButton.styleFrom(
                foregroundColor: AsanaColors.red,
                side: BorderSide(color: AsanaColors.red.withOpacity(0.5)),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Text('Delete Account'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
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
          Row(
            children: [
              Icon(icon, color: AsanaColors.textSecondary, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: AsanaColors.textPrimary,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildToggleRow({
    required String title,
    String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
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
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: AsanaColors.textMuted,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AsanaColors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildActionRow({
    required String title,
    String? subtitle,
    required IconData icon,
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
              Icon(icon, color: AsanaColors.textSecondary, size: 20),
              const SizedBox(width: 12),
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
                    if (subtitle != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: TextStyle(
                          color: AsanaColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(Icons.chevron_right, color: AsanaColors.textMuted, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSelectRow({
    required String title,
    required String value,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                color: AsanaColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          PopupMenuButton<String>(
            onSelected: onSelected,
            itemBuilder: (context) => options.map((option) {
              return PopupMenuItem(
                value: option,
                child: Row(
                  children: [
                    if (option == value)
                      Icon(Icons.check, color: AsanaColors.green, size: 18)
                    else
                      const SizedBox(width: 18),
                    const SizedBox(width: 8),
                    Text(option),
                  ],
                ),
              );
            }).toList(),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                border: Border.all(color: AsanaColors.border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    value,
                    style: TextStyle(
                      color: AsanaColors.textPrimary,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.expand_more,
                      color: AsanaColors.textMuted, size: 18),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              color: AsanaColors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: AsanaColors.textMuted,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showExportDialog(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Export $type'),
        content: Text('Your $type will be prepared for download.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AsanaColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$type export started'),
                  backgroundColor: AsanaColors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AsanaColors.green,
              foregroundColor: Colors.white,
            ),
            child: const Text('Export'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Clear Cache'),
        content: const Text(
            'This will remove all cached data. You may need to reload some content.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AsanaColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Cache cleared successfully'),
                  backgroundColor: AsanaColors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AsanaColors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmation(SettingsProvider provider) {
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

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: AsanaColors.red),
            const SizedBox(width: 8),
            const Text('Delete Account'),
          ],
        ),
        content: const Text(
          'This action is permanent and cannot be undone. All your data will be permanently deleted.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel',
                style: TextStyle(color: AsanaColors.textSecondary)),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement account deletion
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AsanaColors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete Account'),
          ),
        ],
      ),
    );
  }
}
