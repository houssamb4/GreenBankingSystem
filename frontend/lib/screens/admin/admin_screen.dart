// Placeholder for Admin Dashboard - Implement when needed
// This file serves as a template for the admin panel

import 'package:flutter/material.dart';
import 'package:frontend/config/theme.dart';

// NOTE: Admin functionality requires elevated privileges
// This should be restricted to admin users only

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  late PageController _pageController;
  int _selectedTab = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        elevation: 1,
        shadowColor: AppTheme.borderLight,
      ),
      body: Column(
        children: [
          // Tab Navigation
          Container(
            color: AppTheme.white,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _AdminTab(
                    label: 'Categories',
                    icon: Icons.category,
                    isSelected: _selectedTab == 0,
                    onTap: () => setState(() => _selectedTab = 0),
                  ),
                  _AdminTab(
                    label: 'Emission Factors',
                    icon: Icons.science,
                    isSelected: _selectedTab == 1,
                    onTap: () => setState(() => _selectedTab = 1),
                  ),
                  _AdminTab(
                    label: 'Merchant Rules',
                    icon: Icons.rule,
                    isSelected: _selectedTab == 2,
                    onTap: () => setState(() => _selectedTab = 2),
                  ),
                  _AdminTab(
                    label: 'Logs',
                    icon: Icons.history,
                    isSelected: _selectedTab == 3,
                    onTap: () => setState(() => _selectedTab = 3),
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1, color: AppTheme.borderLight),
          // Content
          Expanded(child: _buildTabContent(_selectedTab)),
        ],
      ),
    );
  }

  Widget _buildTabContent(int index) {
    switch (index) {
      case 0:
        return _AdminCategoriesTab();
      case 1:
        return _AdminEmissionFactorsTab();
      case 2:
        return _AdminMerchantRulesTab();
      case 3:
        return _AdminLogsTab();
      default:
        return const Center(child: Text('Unknown Tab'));
    }
  }
}

class _AdminTab extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _AdminTab({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.paddingLarge,
            vertical: AppTheme.paddingMedium,
          ),
          decoration: BoxDecoration(
            border: isSelected
                ? Border(
                    bottom: BorderSide(
                      color: AppTheme.primaryDarkGreen,
                      width: 3,
                    ),
                  )
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AppTheme.primaryDarkGreen
                    : AppTheme.textMedium,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppTheme.primaryDarkGreen
                      : AppTheme.textMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Admin Tab: Categories Management
class _AdminCategoriesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Categories', style: Theme.of(context).textTheme.titleLarge),
              ElevatedButton.icon(
                onPressed: () {
                  // Show create category dialog
                },
                icon: const Icon(Icons.add),
                label: const Text('New Category'),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          // Category list (DataTable on desktop, cards on mobile)
          Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
              boxShadow: const [AppTheme.softShadow],
            ),
            child: const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Name')),
                  DataColumn(label: Text('Icon')),
                  DataColumn(label: Text('Created')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: [],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Admin Tab: Emission Factors
class _AdminEmissionFactorsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Emission Factors',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Show create factor dialog
                },
                icon: const Icon(Icons.add),
                label: const Text('New Factor'),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
              boxShadow: const [AppTheme.softShadow],
            ),
            child: const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Value')),
                  DataColumn(label: Text('Unit')),
                  DataColumn(label: Text('Effective Date')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: [],
              ),
            ),
          ),
          const SizedBox(height: AppTheme.paddingLarge),
          Text('History', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppTheme.paddingMedium),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
              boxShadow: const [AppTheme.softShadow],
            ),
            padding: const EdgeInsets.all(AppTheme.paddingMedium),
            child: const Text(
              'Previous factor versions will be displayed here',
            ),
          ),
        ],
      ),
    );
  }
}

/// Admin Tab: Merchant Rules
class _AdminMerchantRulesTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Merchant Rules',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Show create rule dialog
                },
                icon: const Icon(Icons.add),
                label: const Text('New Rule'),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          Text(
            'Pattern Matching for Auto-Categorization',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
              boxShadow: const [AppTheme.softShadow],
            ),
            child: const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Pattern')),
                  DataColumn(label: Text('Merchant Name')),
                  DataColumn(label: Text('Category')),
                  DataColumn(label: Text('Match Count')),
                  DataColumn(label: Text('Actions')),
                ],
                rows: [],
              ),
            ),
          ),
          const SizedBox(height: AppTheme.paddingLarge),
          Text('Test Rule', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: AppTheme.paddingMedium),
          Container(
            padding: const EdgeInsets.all(AppTheme.paddingMedium),
            decoration: BoxDecoration(
              color: AppTheme.backgroundNeutral,
              borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  decoration: const InputDecoration(
                    hintText: 'Enter merchant name to test...',
                  ),
                ),
                const SizedBox(height: AppTheme.paddingMedium),
                ElevatedButton(
                  onPressed: () {
                    // Test matching
                  },
                  child: const Text('Test'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Admin Tab: Logs & Calculations
class _AdminLogsTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppTheme.paddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Calculation Logs',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  // Export logs
                },
                icon: const Icon(Icons.download),
                label: const Text('Export'),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          TextField(
            decoration: const InputDecoration(
              hintText: 'Search logs...',
              prefixIcon: Icon(Icons.search),
            ),
          ),
          const SizedBox(height: AppTheme.paddingMedium),
          Container(
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
              boxShadow: const [AppTheme.softShadow],
            ),
            child: const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text('Timestamp')),
                  DataColumn(label: Text('Transaction')),
                  DataColumn(label: Text('Amount')),
                  DataColumn(label: Text('Calculated CO₂')),
                  DataColumn(label: Text('Factor Used')),
                  DataColumn(label: Text('Status')),
                ],
                rows: [],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
