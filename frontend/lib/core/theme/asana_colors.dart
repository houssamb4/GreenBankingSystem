import 'dart:ui';

/// Asana-inspired color palette for the GreenPay app
/// Provides a consistent, modern color scheme with green banking theme
class AsanaColors {
  // Background colors
  static const Color pageBg = Color(0xFFF8F9FA);
  static const Color sidebarBg = Color(0xFF1E1F21);
  static const Color inputBg = Color(0xFFF1F2F4);
  static const Color hoverBg = Color(0xFF2E2F31);
  static const Color selectedBg = Color(0xFF2E2F31);
  static const Color badgeBg = Color(0xFF3D3E40);

  // Border colors
  static const Color border = Color(0xFFE5E5E5);

  // Primary colors - Green banking theme
  static const Color green = Color(0xFF10B981);
  static const Color teal = Color(0xFF14B8A6);
  static const Color blue = Color(0xFF3B82F6);
  static const Color purple = Color(0xFF8B5CF6);
  static const Color pink = Color(0xFFEC4899);
  static const Color yellow = Color(0xFFF59E0B);
  static const Color orange = Color(0xFFF97316);
  static const Color red = Color(0xFFEF4444);

  // Text colors
  static const Color textPrimary = Color(0xFF1E1F21);
  static const Color textSecondary = Color(0xFF6D6E6F);
  static const Color textMuted = Color(0xFF9DA2A6);

  // Utility method for lighter shades
  static Color withLightOpacity(Color color, double opacity) {
    return color.withOpacity(opacity);
  }
}
