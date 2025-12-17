import 'package:flutter/material.dart';
import 'package:greenpay/core/theme/global_colors.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: GlobalColors.text,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Profile Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFF0FDF4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: const Color(0xFF10B981).withOpacity(0.3),
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF10B981).withOpacity(0.2),
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person,
                      size: 50,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'John Doe',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'john.doe@example.com',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF10B981),
                    ),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Handle edit profile
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF10B981),
                      side: const BorderSide(
                        color: Color(0xFF10B981),
                      ),
                    ),
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit Profile'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Stats
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Green Score', '78/100'),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard('Monthly CO₂', '42.5 kg'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Account Settings
            _buildSettingsSection('Account Settings', [
              _buildSettingsTile(
                'Personal Information',
                'Name, email, phone',
                Icons.person_outline,
                onTap: () {
                  // TODO: Navigate to personal info
                },
              ),
              _buildSettingsTile(
                'Security',
                'Password, two-factor auth',
                Icons.security,
                onTap: () {
                  // TODO: Navigate to security settings
                },
              ),
              _buildSettingsTile(
                'Payment Methods',
                'Cards, bank accounts',
                Icons.payment,
                onTap: () {
                  // TODO: Navigate to payment methods
                },
              ),
            ]),
            const SizedBox(height: 24),
            // Preferences
            _buildSettingsSection('Preferences', [
              _buildSettingsTile(
                'Notifications',
                'Carbon alerts, offers',
                Icons.notifications_outlined,
                onTap: () {
                  // TODO: Navigate to notifications
                },
              ),
              _buildSettingsTile(
                'Privacy',
                'Data & privacy settings',
                Icons.privacy_tip_outlined,
                onTap: () {
                  // TODO: Navigate to privacy
                },
              ),
            ]),
            const SizedBox(height: 24),
            // Support
            _buildSettingsSection('Support & About', [
              _buildSettingsTile(
                'Help & Support',
                'FAQs, contact support',
                Icons.help_outline,
                onTap: () {
                  // TODO: Navigate to help
                },
              ),
              _buildSettingsTile(
                'Terms & Privacy',
                'Legal documents',
                Icons.description_outlined,
                onTap: () {
                  // TODO: Navigate to terms
                },
              ),
              _buildSettingsTile(
                'About GreenPay',
                'Version, company info',
                Icons.info_outlined,
                onTap: () {
                  // TODO: Navigate to about
                },
              ),
            ]),
            const SizedBox(height: 24),
            // Logout Button
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showLogoutConfirmation(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEF4444),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.logout),
                label: const Text('Logout'),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  static Widget _buildStatCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: GlobalColors.textSecondary,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildSettingsSection(String title, List<Widget> items) {
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

  static Widget _buildSettingsTile(
    String title,
    String subtitle,
    IconData icon, {
    required VoidCallback onTap,
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

  static void _showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/signIn', (route) => false);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
