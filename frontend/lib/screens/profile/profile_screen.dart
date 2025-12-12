import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/config/theme.dart';
import 'package:frontend/config/router.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _currency = 'EUR';
  String _carbonUnit = 'kg';
  bool _notificationsEnabled = true;
  bool _twoFAEnabled = false;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Settings'),
        elevation: 1,
        shadowColor: AppTheme.borderLight,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.paddingLarge),
        child: isDesktop
            ? _DesktopProfileLayout(
                currency: _currency,
                carbonUnit: _carbonUnit,
                notificationsEnabled: _notificationsEnabled,
                twoFAEnabled: _twoFAEnabled,
                onCurrencyChanged: (value) => setState(() => _currency = value),
                onCarbonUnitChanged: (value) =>
                    setState(() => _carbonUnit = value),
                onNotificationsChanged: (value) =>
                    setState(() => _notificationsEnabled = value),
                onTwoFAChanged: (value) =>
                    setState(() => _twoFAEnabled = value),
              )
            : _MobileProfileLayout(
                currency: _currency,
                carbonUnit: _carbonUnit,
                notificationsEnabled: _notificationsEnabled,
                twoFAEnabled: _twoFAEnabled,
                onCurrencyChanged: (value) => setState(() => _currency = value),
                onCarbonUnitChanged: (value) =>
                    setState(() => _carbonUnit = value),
                onNotificationsChanged: (value) =>
                    setState(() => _notificationsEnabled = value),
                onTwoFAChanged: (value) =>
                    setState(() => _twoFAEnabled = value),
              ),
      ),
    );
  }
}

class _DesktopProfileLayout extends StatelessWidget {
  final String currency;
  final String carbonUnit;
  final bool notificationsEnabled;
  final bool twoFAEnabled;
  final Function(String) onCurrencyChanged;
  final Function(String) onCarbonUnitChanged;
  final Function(bool) onNotificationsChanged;
  final Function(bool) onTwoFAChanged;

  const _DesktopProfileLayout({
    required this.currency,
    required this.carbonUnit,
    required this.notificationsEnabled,
    required this.twoFAEnabled,
    required this.onCurrencyChanged,
    required this.onCarbonUnitChanged,
    required this.onNotificationsChanged,
    required this.onTwoFAChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _UserInfoSection(),
              const SizedBox(height: AppTheme.paddingXLarge),
              _PreferencesSection(
                currency: currency,
                carbonUnit: carbonUnit,
                onCurrencyChanged: onCurrencyChanged,
                onCarbonUnitChanged: onCarbonUnitChanged,
              ),
              const SizedBox(height: AppTheme.paddingXLarge),
              _SecuritySection(
                notificationsEnabled: notificationsEnabled,
                twoFAEnabled: twoFAEnabled,
                onNotificationsChanged: onNotificationsChanged,
                onTwoFAChanged: onTwoFAChanged,
              ),
            ],
          ),
        ),
        const SizedBox(width: AppTheme.paddingXLarge),
        Expanded(flex: 1, child: _DangerZoneSection()),
      ],
    );
  }
}

class _MobileProfileLayout extends StatelessWidget {
  final String currency;
  final String carbonUnit;
  final bool notificationsEnabled;
  final bool twoFAEnabled;
  final Function(String) onCurrencyChanged;
  final Function(String) onCarbonUnitChanged;
  final Function(bool) onNotificationsChanged;
  final Function(bool) onTwoFAChanged;

  const _MobileProfileLayout({
    required this.currency,
    required this.carbonUnit,
    required this.notificationsEnabled,
    required this.twoFAEnabled,
    required this.onCurrencyChanged,
    required this.onCarbonUnitChanged,
    required this.onNotificationsChanged,
    required this.onTwoFAChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _UserInfoSection(),
        const SizedBox(height: AppTheme.paddingXLarge),
        _PreferencesSection(
          currency: currency,
          carbonUnit: carbonUnit,
          onCurrencyChanged: onCurrencyChanged,
          onCarbonUnitChanged: onCarbonUnitChanged,
        ),
        const SizedBox(height: AppTheme.paddingXLarge),
        _SecuritySection(
          notificationsEnabled: notificationsEnabled,
          twoFAEnabled: twoFAEnabled,
          onNotificationsChanged: onNotificationsChanged,
          onTwoFAChanged: onTwoFAChanged,
        ),
        const SizedBox(height: AppTheme.paddingXLarge),
        _DangerZoneSection(),
      ],
    );
  }
}

class _UserInfoSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
        boxShadow: const [AppTheme.softShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Profile Information',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryLightGreen,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(
                    child: Icon(Icons.person, color: AppTheme.white, size: 40),
                  ),
                ),
                const SizedBox(height: AppTheme.paddingMedium),
                Text(
                  'John Doe',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'john@example.com',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          const Divider(color: AppTheme.borderLight),
          const SizedBox(height: AppTheme.paddingMedium),
          _InfoRow(label: 'Member Since', value: 'January 2024'),
          const SizedBox(height: AppTheme.paddingSmall),
          _InfoRow(label: 'Account Status', value: 'Active'),
          const SizedBox(height: AppTheme.paddingMedium),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.white,
                foregroundColor: AppTheme.primaryDarkGreen,
                side: const BorderSide(color: AppTheme.borderLight),
              ),
              child: const Text('Edit Profile'),
            ),
          ),
        ],
      ),
    );
  }
}

class _PreferencesSection extends StatelessWidget {
  final String currency;
  final String carbonUnit;
  final Function(String) onCurrencyChanged;
  final Function(String) onCarbonUnitChanged;

  const _PreferencesSection({
    required this.currency,
    required this.carbonUnit,
    required this.onCurrencyChanged,
    required this.onCarbonUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
        boxShadow: const [AppTheme.softShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Display Preferences',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          Text('Currency', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.paddingMedium,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.borderLight),
              borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
            ),
            child: DropdownButton<String>(
              value: currency,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: ['EUR', 'USD', 'GBP'].map((c) {
                return DropdownMenuItem(value: c, child: Text(c));
              }).toList(),
              onChanged: (value) => onCurrencyChanged(value ?? 'EUR'),
            ),
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          Text('Carbon Unit', style: Theme.of(context).textTheme.labelMedium),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppTheme.paddingMedium,
            ),
            decoration: BoxDecoration(
              border: Border.all(color: AppTheme.borderLight),
              borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
            ),
            child: DropdownButton<String>(
              value: carbonUnit,
              isExpanded: true,
              underline: const SizedBox.shrink(),
              items: ['kg', 'g', 'tons'].map((u) {
                return DropdownMenuItem(value: u, child: Text(u));
              }).toList(),
              onChanged: (value) => onCarbonUnitChanged(value ?? 'kg'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SecuritySection extends StatelessWidget {
  final bool notificationsEnabled;
  final bool twoFAEnabled;
  final Function(bool) onNotificationsChanged;
  final Function(bool) onTwoFAChanged;

  const _SecuritySection({
    required this.notificationsEnabled,
    required this.twoFAEnabled,
    required this.onNotificationsChanged,
    required this.onTwoFAChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
        boxShadow: const [AppTheme.softShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Security & Notifications',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          SwitchListTile(
            title: Text(
              'Email Notifications',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            subtitle: Text(
              'Receive weekly carbon footprint reports',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            value: notificationsEnabled,
            onChanged: onNotificationsChanged,
            activeColor: AppTheme.primaryDarkGreen,
          ),
          const Divider(color: AppTheme.borderLight),
          SwitchListTile(
            title: Text(
              'Two-Factor Authentication',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            subtitle: Text(
              'Add an extra layer of security',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            value: twoFAEnabled,
            onChanged: onTwoFAChanged,
            activeColor: AppTheme.primaryDarkGreen,
          ),
        ],
      ),
    );
  }
}

class _DangerZoneSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.paddingMedium),
      decoration: BoxDecoration(
        color: AppTheme.errorRed.withOpacity(0.05),
        borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
        border: Border.all(color: AppTheme.errorRed),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Danger Zone',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: AppTheme.errorRed,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          Text(
            'Irreversible actions',
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: AppTheme.textMedium),
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorRed,
              ),
              child: const Text('Change Password'),
            ),
          ),
          const SizedBox(height: AppTheme.paddingSmall),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.errorRed,
              ),
              child: const Text('Delete Account'),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppTheme.textMedium),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
