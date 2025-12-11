import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend/config/theme.dart';
import 'package:frontend/config/router.dart';

class MainLayout extends StatefulWidget {
  final Widget child;

  const MainLayout({Key? key, required this.child}) : super(key: key);

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _selectedIndex = 0;

  final List<_NavItem> _navItems = [
    _NavItem(label: 'Dashboard', icon: Icons.home, route: Routes.dashboard),
    _NavItem(
      label: 'Transactions',
      icon: Icons.receipt,
      route: Routes.transactions,
    ),
    _NavItem(label: 'Reports', icon: Icons.bar_chart, route: Routes.reports),
    _NavItem(label: 'Advice', icon: Icons.lightbulb, route: Routes.advice),
    _NavItem(label: 'Profile', icon: Icons.person, route: Routes.profile),
  ];

  void _onNavItemTap(int index) {
    setState(() => _selectedIndex = index);
    context.go(_navItems[index].route);
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;

    if (isDesktop) {
      return _DesktopLayout(
        selectedIndex: _selectedIndex,
        navItems: _navItems,
        onNavItemTap: _onNavItemTap,
        child: widget.child,
      );
    } else {
      return _MobileLayout(
        selectedIndex: _selectedIndex,
        navItems: _navItems,
        onNavItemTap: _onNavItemTap,
        child: widget.child,
      );
    }
  }
}

class _DesktopLayout extends StatelessWidget {
  final int selectedIndex;
  final List<_NavItem> navItems;
  final Function(int) onNavItemTap;
  final Widget child;

  const _DesktopLayout({
    required this.selectedIndex,
    required this.navItems,
    required this.onNavItemTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Container(
            width: 280,
            color: AppTheme.white,
            child: Column(
              children: [
                // Logo/Brand
                Padding(
                  padding: const EdgeInsets.all(AppTheme.paddingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryDarkGreen,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text('🌱', style: TextStyle(fontSize: 24)),
                        ),
                      ),
                      const SizedBox(height: AppTheme.paddingSmall),
                      const Text(
                        'Green Banking',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textDark,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(color: AppTheme.borderLight),
                // Navigation Items
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.paddingSmall,
                    ),
                    itemCount: navItems.length,
                    itemBuilder: (context, index) {
                      final item = navItems[index];
                      final isSelected = selectedIndex == index;

                      return _SidebarNavItem(
                        label: item.label,
                        icon: item.icon,
                        isSelected: isSelected,
                        onTap: () => onNavItemTap(index),
                      );
                    },
                  ),
                ),
                const Divider(color: AppTheme.borderLight),
                // User Profile Section
                Padding(
                  padding: const EdgeInsets.all(AppTheme.paddingMedium),
                  child: Material(
                    color: AppTheme.backgroundNeutral,
                    borderRadius: BorderRadius.circular(AppTheme.cornerRadius),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(
                        AppTheme.cornerRadius,
                      ),
                      onTap: () => context.go(Routes.profile),
                      child: Padding(
                        padding: const EdgeInsets.all(AppTheme.paddingMedium),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppTheme.primaryLightGreen,
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.person,
                                  color: AppTheme.white,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: AppTheme.paddingMedium),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'John Doe',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: AppTheme.textDark,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'john@example.com',
                                    style: Theme.of(
                                      context,
                                    ).textTheme.labelSmall,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: Column(
              children: [
                // Top App Bar
                Container(
                  height: 64,
                  color: AppTheme.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.paddingLarge,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.notifications),
                        onPressed: () {},
                        color: AppTheme.textDark,
                      ),
                      const SizedBox(width: AppTheme.paddingMedium),
                      IconButton(
                        icon: const Icon(Icons.settings),
                        onPressed: () => context.go(Routes.profile),
                        color: AppTheme.textDark,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1, color: AppTheme.borderLight),
                // Page Content
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MobileLayout extends StatelessWidget {
  final int selectedIndex;
  final List<_NavItem> navItems;
  final Function(int) onNavItemTap;
  final Widget child;

  const _MobileLayout({
    required this.selectedIndex,
    required this.navItems,
    required this.onNavItemTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      drawer: Drawer(
        child: Column(
          children: [
            // Drawer Header
            DrawerHeader(
              decoration: const BoxDecoration(color: AppTheme.primaryDarkGreen),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '🌱 Green Banking',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.white,
                    ),
                  ),
                  const SizedBox(height: AppTheme.paddingSmall),
                  const Text(
                    'Track your carbon footprint',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppTheme.primaryLightGreen,
                    ),
                  ),
                ],
              ),
            ),
            // Navigation Items
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: AppTheme.paddingSmall,
                ),
                itemCount: navItems.length,
                itemBuilder: (context, index) {
                  final item = navItems[index];
                  final isSelected = selectedIndex == index;

                  return _DrawerNavItem(
                    label: item.label,
                    icon: item.icon,
                    isSelected: isSelected,
                    onTap: () {
                      onNavItemTap(index);
                      Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ),
            const Divider(color: AppTheme.borderLight),
            // User Profile in Drawer
            ListTile(
              leading: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppTheme.primaryLightGreen,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Icon(Icons.person, color: AppTheme.white, size: 20),
                ),
              ),
              title: const Text('Profile'),
              onTap: () {
                context.go(Routes.profile);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go(Routes.addTransaction),
        tooltip: 'Add Transaction',
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        notchMargin: 8.0,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.paddingSmall,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate((navItems.length / 2).ceil() * 2, (index) {
              if (index == navItems.length ~/ 2) {
                return const SizedBox(width: 48);
              }
              if (index > navItems.length - 1) {
                return const SizedBox(width: 48);
              }

              final item = navItems[index];
              final isSelected = selectedIndex == index;

              return _BottomNavItem(
                label: item.label,
                icon: item.icon,
                isSelected: isSelected,
                onTap: () => onNavItemTap(index),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _SidebarNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _SidebarNavItem({
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
          margin: const EdgeInsets.symmetric(
            horizontal: AppTheme.paddingSmall,
            vertical: 4,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppTheme.paddingMedium,
            vertical: AppTheme.paddingMedium,
          ),
          decoration: BoxDecoration(
            color: isSelected
                ? AppTheme.primaryDarkGreen.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppTheme.smallCornerRadius),
            border: isSelected
                ? Border.all(color: AppTheme.primaryDarkGreen, width: 1)
                : null,
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? AppTheme.primaryDarkGreen
                    : AppTheme.textMedium,
                size: 20,
              ),
              const SizedBox(width: AppTheme.paddingMedium),
              Text(
                label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected
                      ? AppTheme.primaryDarkGreen
                      : AppTheme.textDark,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DrawerNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _DrawerNavItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        color: isSelected ? AppTheme.primaryDarkGreen : AppTheme.textMedium,
      ),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          color: isSelected ? AppTheme.primaryDarkGreen : AppTheme.textDark,
        ),
      ),
      selected: isSelected,
      selectedTileColor: AppTheme.primaryDarkGreen.withOpacity(0.1),
      onTap: onTap,
    );
  }
}

class _BottomNavItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _BottomNavItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  icon,
                  color: isSelected
                      ? AppTheme.primaryDarkGreen
                      : AppTheme.textMedium,
                  size: 20,
                ),
                const SizedBox(height: 4),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                    color: isSelected
                        ? AppTheme.primaryDarkGreen
                        : AppTheme.textMedium,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final String route;

  _NavItem({required this.label, required this.icon, required this.route});
}
