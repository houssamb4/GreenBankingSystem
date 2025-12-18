import 'package:flutter/material.dart';
import 'package:greenpay/core/theme/global_colors.dart';
import 'package:greenpay/widgets/app_drawer.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _darkMode = false;
  bool _carbonAlerts = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: GlobalColors.text,
        elevation: 0,
      ),
      drawer: const AppDrawer(currentRoute: '/settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // App Preferences
            _buildSettingsSection('App Preferences', [
              _buildToggleTile(
                'Dark Mode',
                'Use dark theme for better visibility at night',
                Icons.dark_mode,
                _darkMode,
                (value) {
                  setState(() => _darkMode = value);
                },
              ),
              _buildToggleTile(
                'Monthly Carbon Alerts',
                'Get notified about your carbon footprint',
                Icons.notifications_active,
                _carbonAlerts,
                (value) {
                  setState(() => _carbonAlerts = value);
                },
              ),
            ]),
            const SizedBox(height: 24),
            // Language & Region
            _buildSettingsSection('Language & Region', [
              _buildSelectableTile(
                'Language',
                'English',
                Icons.language,
              ),
              _buildSelectableTile(
                'Currency',
                r'USD ($)',
                Icons.attach_money,
              ),
            ]),
            const SizedBox(height: 24),
            // Data & Export
            _buildSettingsSection('Data & Export', [
              _buildActionTile(
                'Export Carbon Report',
                'Download your monthly report as PDF',
                Icons.download,
                onTap: () {
                  _showExportDialog();
                },
              ),
              _buildActionTile(
                'Export Transaction History',
                'Download all transactions as CSV',
                Icons.table_chart,
                onTap: () {
                  _showExportDialog();
                },
              ),
            ]),
            const SizedBox(height: 24),
            // Storage & Cache
            _buildSettingsSection('Storage', [
              _buildSelectableTile(
                'Cache Size',
                '15.2 MB',
                Icons.storage,
              ),
              _buildActionTile(
                'Clear Cache',
                'Remove cached data to free up storage',
                Icons.delete_outline,
                onTap: () {
                  _showClearCacheDialog();
                },
              ),
            ]),
            const SizedBox(height: 24),
            // Privacy & Security
            _buildSettingsSection('Privacy & Security', [
              _buildActionTile(
                'Manage Permissions',
                'Control app access to your data',
                Icons.lock_outline,
              ),
              _buildActionTile(
                'Data Privacy',
                'Review how we handle your data',
                Icons.privacy_tip_outlined,
              ),
            ]),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection(String title, List<Widget> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: GlobalColors.text,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE5E7EB)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
              ),
            ],
          ),
          child: Column(children: items),
        ),
      ],
    );
  }

  Widget _buildToggleTile(
    String title,
    String subtitle,
    IconData icon,
    bool value,
    ValueChanged<bool> onChanged,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF10B981),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: GlobalColors.text,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: GlobalColors.textSecondary,
        ),
      ),
      trailing: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: const Color(0xFF10B981),
      ),
    );
  }

  Widget _buildSelectableTile(
    String title,
    String value,
    IconData icon,
  ) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF10B981),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: GlobalColors.text,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              color: GlobalColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 8),
          const Icon(
            Icons.arrow_forward_ios,
            size: 14,
            color: GlobalColors.textSecondary,
          ),
        ],
      ),
      onTap: () {
        // TODO: Navigate to selection
      },
    );
  }

  Widget _buildActionTile(
    String title,
    String subtitle,
    IconData icon, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: const Color(0xFF10B981),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: GlobalColors.text,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontSize: 12,
          color: GlobalColors.textSecondary,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: GlobalColors.textSecondary,
      ),
      onTap: onTap,
    );
  }

  void _showExportDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export Report'),
        content: const Text(
            'Your report is being prepared. You will receive it via email shortly.'),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF10B981),
            ),
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
            'Are you sure you want to clear the app cache? This will free up storage space.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Cache cleared successfully'),
                  backgroundColor: Color(0xFF10B981),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }
}
