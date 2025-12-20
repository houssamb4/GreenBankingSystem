import 'package:flutter/material.dart';
import 'package:greenpay/core/theme/global_colors.dart';
import 'package:greenpay/core/theme/asana_colors.dart';

/// Alias for Sidebar widget for backwards compatibility
typedef AsanaSidebar = Sidebar;

/// App sidebar navigation component
class Sidebar extends StatefulWidget {
  final String currentRoute;
  final String userName;
  final String userEmail;
  final String userInitials;
  final VoidCallback? onLogout;
  final bool isExpanded;
  final Function(bool)? onExpandedChanged;

  const Sidebar({
    Key? key,
    required this.currentRoute,
    this.userName = 'User',
    this.userEmail = '',
    this.userInitials = 'U',
    this.onLogout,
    this.isExpanded = true,
    this.onExpandedChanged,
  }) : super(key: key);

  @override
  State<Sidebar> createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  late bool _isExpanded;
  bool _isHovering = false;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: _isExpanded ? 260 : 72,
        decoration: BoxDecoration(
          color: AsanaColors.sidebarBg,
          border: Border(
            right: BorderSide(
              color: AsanaColors.border,
              width: 1,
            ),
          ),
        ),
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 8),
            _buildSearchBar(),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildNavSection(
                      items: [
                        _NavItem(
                          icon: Icons.home_rounded,
                          label: 'Home',
                          route: '/dashboard',
                        ),
                        _NavItem(
                          icon: Icons.receipt_long_rounded,
                          label: 'Transactions',
                          route: '/transactions',
                        ),
                        _NavItem(
                          icon: Icons.person_outline_rounded,
                          label: 'Profile',
                          route: '/profile',
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Insights'),
                    _buildNavSection(
                      items: [
                        _NavItem(
                          icon: Icons.eco_rounded,
                          label: 'Carbon Impact',
                          route: '/impact',
                          iconColor: AsanaColors.green,
                        ),
                        _NavItem(
                          icon: Icons.lightbulb_outline_rounded,
                          label: 'Green Tips',
                          route: '/tips',
                          iconColor: AsanaColors.yellow,
                        ),
                        _NavItem(
                          icon: Icons.settings_outlined,
                          label: 'Settings',
                          route: '/settings',
                          iconColor: AsanaColors.textSecondary,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Projects'),
                    _buildProjectsList(),
                    const SizedBox(height: 24),
                    _buildSectionHeader('Goals'),
                    _buildGoalsList(),
                  ],
                ),
              ),
            ),
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AsanaColors.green, AsanaColors.teal],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Center(
              child: Icon(
                Icons.eco_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
          if (_isExpanded) ...[
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GreenPay',
                    style: TextStyle(
                      color: AsanaColors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Sustainable Banking',
                    style: TextStyle(
                      color: AsanaColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(
                _isExpanded ? Icons.chevron_left : Icons.chevron_right,
                color: AsanaColors.textSecondary,
                size: 20,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
                widget.onExpandedChanged?.call(_isExpanded);
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    if (!_isExpanded) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: AsanaColors.inputBg,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            Icons.search,
            color: AsanaColors.textSecondary,
            size: 20,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: AsanaColors.inputBg,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AsanaColors.border),
        ),
        child: Row(
          children: [
            const SizedBox(width: 12),
            Icon(
              Icons.search,
              color: AsanaColors.textSecondary,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                style: TextStyle(
                  color: AsanaColors.textPrimary,
                  fontSize: 14,
                ),
                decoration: InputDecoration(
                  hintText: 'Search',
                  hintStyle: TextStyle(
                    color: AsanaColors.textSecondary,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    if (!_isExpanded) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              color: AsanaColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
          Icon(
            Icons.add,
            color: AsanaColors.textSecondary,
            size: 16,
          ),
        ],
      ),
    );
  }

  Widget _buildNavSection({required List<_NavItem> items}) {
    return Column(
      children: items.map((item) => _buildNavTile(item)).toList(),
    );
  }

  Widget _buildNavTile(_NavItem item) {
    final isSelected = widget.currentRoute == item.route;

    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            if (item.route.isNotEmpty) {
              Navigator.of(context).pushReplacementNamed(item.route);
            }
          },
          borderRadius: BorderRadius.circular(8),
          hoverColor: AsanaColors.hoverBg,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 150),
            padding: EdgeInsets.symmetric(
              horizontal: _isExpanded ? 12 : 8,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              color: isSelected ? AsanaColors.selectedBg : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Icon(
                  item.icon,
                  color: item.iconColor ??
                      (isSelected
                          ? AsanaColors.textPrimary
                          : AsanaColors.textSecondary),
                  size: 20,
                ),
                if (_isExpanded) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      item.label,
                      style: TextStyle(
                        color: isSelected
                            ? AsanaColors.textPrimary
                            : AsanaColors.textSecondary,
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (item.badge != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AsanaColors.badgeBg,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item.badge!,
                        style: TextStyle(
                          color: AsanaColors.textSecondary,
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProjectsList() {
    final projects = [
      ('Savings Goal', AsanaColors.green, 0.75),
      ('Carbon Reduction', AsanaColors.teal, 0.45),
      ('Monthly Budget', AsanaColors.purple, 0.90),
    ];

    return Column(
      children: projects.map((project) {
        return _buildProjectTile(project.$1, project.$2, project.$3);
      }).toList(),
    );
  }

  Widget _buildProjectTile(String name, Color color, double progress) {
    if (!_isExpanded) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              name[0],
              style: TextStyle(
                color: color,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8),
          hoverColor: AsanaColors.hoverBg,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      color: AsanaColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
                SizedBox(
                  width: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: LinearProgressIndicator(
                      value: progress,
                      backgroundColor: AsanaColors.border,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      minHeight: 4,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGoalsList() {
    final goals = [
      ('Net Zero 2025', Icons.flag_rounded, AsanaColors.green),
      ('50% Carbon Cut', Icons.trending_down_rounded, AsanaColors.teal),
    ];

    return Column(
      children: goals.map((goal) {
        return _buildGoalTile(goal.$1, goal.$2, goal.$3);
      }).toList(),
    );
  }

  Widget _buildGoalTile(String name, IconData icon, Color color) {
    if (!_isExpanded) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(8),
          hoverColor: AsanaColors.hoverBg,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Icon(icon, color: color, size: 18),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    name,
                    style: TextStyle(
                      color: AsanaColors.textSecondary,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AsanaColors.border),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/profile'),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AsanaColors.purple, AsanaColors.pink],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Center(
                child: Text(
                  widget.userInitials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
          if (_isExpanded) ...[
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => Navigator.of(context).pushNamed('/profile'),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.userName,
                      style: TextStyle(
                        color: AsanaColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      widget.userEmail,
                      style: TextStyle(
                        color: AsanaColors.textSecondary,
                        fontSize: 12,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_horiz,
                color: AsanaColors.textSecondary,
                size: 20,
              ),
              onSelected: (value) {
                if (value == 'logout') {
                  widget.onLogout?.call();
                } else if (value == 'settings') {
                  Navigator.of(context).pushNamed('/settings');
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'settings',
                  child: Row(
                    children: [
                      Icon(Icons.settings_outlined,
                          size: 18, color: AsanaColors.textSecondary),
                      const SizedBox(width: 12),
                      const Text('Settings'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'logout',
                  child: Row(
                    children: [
                      Icon(Icons.logout, size: 18, color: AsanaColors.red),
                      const SizedBox(width: 12),
                      Text('Log out', style: TextStyle(color: AsanaColors.red)),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label;
  final String route;
  final String? badge;
  final Color? iconColor;

  _NavItem({
    required this.icon,
    required this.label,
    required this.route,
    this.iconColor,
  });
}

/// App color palette
class AppColors {
  // Background colors
  static Color get sidebarBg => const Color(0xFFFAFAFA);
  static Color get inputBg => const Color(0xFFF6F8F9);
  static Color get hoverBg => const Color(0xFFF1F3F4);
  static Color get selectedBg => const Color(0xFFE8F0FE);
  static Color get badgeBg => const Color(0xFFEEF0F2);
  static Color get cardBg => Colors.white;
  static Color get pageBg => const Color(0xFFF6F8F9);

  // Text colors
  static Color get textPrimary => const Color(0xFF1E1F21);
  static Color get textSecondary => const Color(0xFF6D6E6F);
  static Color get textMuted => const Color(0xFF9CA3AF);

  // Border colors
  static Color get border => const Color(0xFFE8ECEE);
  static Color get borderHover => const Color(0xFFD1D5DB);

  // Accent colors
  static Color get green => const Color(0xFF10B981);
  static Color get teal => const Color(0xFF14B8A6);
  static Color get blue => const Color(0xFF3B82F6);
  static Color get purple => const Color(0xFF8B5CF6);
  static Color get pink => const Color(0xFFEC4899);
  static Color get orange => const Color(0xFFF97316);
  static Color get yellow => const Color(0xFFF59E0B);
  static Color get red => const Color(0xFFEF4444);

  // Status colors
  static Color get success => const Color(0xFF10B981);
  static Color get warning => const Color(0xFFF59E0B);
  static Color get error => const Color(0xFFEF4444);
  static Color get info => const Color(0xFF3B82F6);
}
