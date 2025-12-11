import 'package:flutter/material.dart';

/// Semantic color definitions for the app.
/// These colors are independent of theme (light/dark) and provide
/// consistent semantic meaning across the application.
class AppColors {
  AppColors._();

  // Brand colors
  static const Color brand = Color(0xFF6200EE);
  static const Color brandLight = Color(0xFFBB86FC);
  static const Color brandDark = Color(0xFF3700B3);

  // Semantic colors - Light theme
  static const LightColors light = LightColors._();

  // Semantic colors - Dark theme
  static const DarkColors dark = DarkColors._();

  // Status colors (shared between themes)
  static const Color success = Color(0xFF4CAF50);
  static const Color successLight = Color(0xFFE8F5E9);
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFF3E0);
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFE3F2FD);
  static const Color error = Color(0xFFE53935);
  static const Color errorLight = Color(0xFFFFEBEE);

  // Neutral colors
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color transparent = Color(0x00000000);

  // Gray scale
  static const Color gray50 = Color(0xFFFAFAFA);
  static const Color gray100 = Color(0xFFF5F5F5);
  static const Color gray200 = Color(0xFFEEEEEE);
  static const Color gray300 = Color(0xFFE0E0E0);
  static const Color gray400 = Color(0xFFBDBDBD);
  static const Color gray500 = Color(0xFF9E9E9E);
  static const Color gray600 = Color(0xFF757575);
  static const Color gray700 = Color(0xFF616161);
  static const Color gray800 = Color(0xFF424242);
  static const Color gray900 = Color(0xFF212121);
}

/// Light theme semantic colors
class LightColors {
  const LightColors._();

  // Background colors
  Color get background => const Color(0xFFFFFBFE);
  Color get surface => const Color(0xFFFFFFFF);
  Color get surfaceVariant => const Color(0xFFF5F5F5);
  Color get card => const Color(0xFFFFFFFF);
  Color get modal => const Color(0xFFFFFFFF);

  // Text colors
  Color get textPrimary => const Color(0xFF1C1B1F);
  Color get textSecondary => const Color(0xFF49454F);
  Color get textTertiary => const Color(0xFF79747E);
  Color get textDisabled => const Color(0xFFBDBDBD);
  Color get textOnPrimary => const Color(0xFFFFFFFF);

  // Border colors
  Color get border => const Color(0xFFE0E0E0);
  Color get borderLight => const Color(0xFFF5F5F5);
  Color get borderDark => const Color(0xFFBDBDBD);
  Color get divider => const Color(0xFFE0E0E0);

  // Interactive colors
  Color get primary => const Color(0xFF6200EE);
  Color get primaryVariant => const Color(0xFF3700B3);
  Color get secondary => const Color(0xFF03DAC6);
  Color get secondaryVariant => const Color(0xFF018786);

  // Feedback colors
  Color get success => const Color(0xFF4CAF50);
  Color get successBackground => const Color(0xFFE8F5E9);
  Color get warning => const Color(0xFFFF9800);
  Color get warningBackground => const Color(0xFFFFF3E0);
  Color get error => const Color(0xFFE53935);
  Color get errorBackground => const Color(0xFFFFEBEE);
  Color get info => const Color(0xFF2196F3);
  Color get infoBackground => const Color(0xFFE3F2FD);

  // Shadow
  Color get shadow => const Color(0x1F000000);
  Color get shadowLight => const Color(0x0F000000);

  // Overlay
  Color get overlay => const Color(0x52000000);
  Color get scrim => const Color(0x52000000);
}

/// Dark theme semantic colors
class DarkColors {
  const DarkColors._();

  // Background colors
  Color get background => const Color(0xFF1C1B1F);
  Color get surface => const Color(0xFF2D2D30);
  Color get surfaceVariant => const Color(0xFF3C3C3F);
  Color get card => const Color(0xFF2D2D30);
  Color get modal => const Color(0xFF3C3C3F);

  // Text colors
  Color get textPrimary => const Color(0xFFE6E1E5);
  Color get textSecondary => const Color(0xFFCAC4D0);
  Color get textTertiary => const Color(0xFF938F99);
  Color get textDisabled => const Color(0xFF49454F);
  Color get textOnPrimary => const Color(0xFF381E72);

  // Border colors
  Color get border => const Color(0xFF49454F);
  Color get borderLight => const Color(0xFF3C3C3F);
  Color get borderDark => const Color(0xFF79747E);
  Color get divider => const Color(0xFF49454F);

  // Interactive colors
  Color get primary => const Color(0xFFBB86FC);
  Color get primaryVariant => const Color(0xFF4F378B);
  Color get secondary => const Color(0xFF03DAC6);
  Color get secondaryVariant => const Color(0xFF004F4D);

  // Feedback colors
  Color get success => const Color(0xFF81C784);
  Color get successBackground => const Color(0xFF1B5E20);
  Color get warning => const Color(0xFFFFB74D);
  Color get warningBackground => const Color(0xFFE65100);
  Color get error => const Color(0xFFCF6679);
  Color get errorBackground => const Color(0xFF93000A);
  Color get info => const Color(0xFF64B5F6);
  Color get infoBackground => const Color(0xFF0D47A1);

  // Shadow
  Color get shadow => const Color(0x3D000000);
  Color get shadowLight => const Color(0x1F000000);

  // Overlay
  Color get overlay => const Color(0x7A000000);
  Color get scrim => const Color(0x7A000000);
}

/// Extension to easily access semantic colors from BuildContext
extension AppColorsExtension on BuildContext {
  /// Get semantic colors based on current theme brightness
  dynamic get colors {
    final brightness = Theme.of(this).brightness;
    return brightness == Brightness.light ? AppColors.light : AppColors.dark;
  }

  /// Check if current theme is dark
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
