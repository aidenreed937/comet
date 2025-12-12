import 'package:flutter/material.dart';

/// Spacing system for consistent layout throughout the app.
/// Based on an 4pt grid system.
class AppSpacing {
  AppSpacing._();

  // Base unit
  static const double unit = 4;

  // Named spacing values
  static const double none = 0;
  static const double xxs = 2; // 0.5x
  static const double xs = 4; // 1x
  static const double sm = 8; // 2x
  static const double md = 16; // 4x
  static const double lg = 24; // 6x
  static const double xl = 32; // 8x
  static const double xxl = 48; // 12x
  static const double xxxl = 64; // 16x

  // Additional spacing for specific use cases
  static const double xl2 = 40; // 10x - for section gaps

  // Component-specific spacing
  static const double buttonPaddingHorizontal = 24;
  static const double buttonPaddingVertical = 12;
  static const double cardPadding = 16;
  static const double listItemPadding = 16;
  static const double screenPadding = 16;
  static const double sectionSpacing = 24;
  static const double inputPaddingHorizontal = 16;
  static const double inputPaddingVertical = 12;

  // Icon sizes
  static const double iconXs = 16;
  static const double iconSm = 20;
  static const double iconMd = 24;
  static const double iconLg = 32;
  static const double iconXl = 48;
  static const double iconXxl = 64;
  static const double iconHero = 80; // For hero/logo icons

  // Border radius
  static const double radiusNone = 0;
  static const double radiusXs = 4;
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const double radiusXl = 24;
  static const double radiusFull = 9999;

  // Border radius presets
  static BorderRadius get borderRadiusXs => BorderRadius.circular(radiusXs);
  static BorderRadius get borderRadiusSm => BorderRadius.circular(radiusSm);
  static BorderRadius get borderRadiusMd => BorderRadius.circular(radiusMd);
  static BorderRadius get borderRadiusLg => BorderRadius.circular(radiusLg);
  static BorderRadius get borderRadiusXl => BorderRadius.circular(radiusXl);
  static BorderRadius get borderRadiusFull => BorderRadius.circular(radiusFull);

  // EdgeInsets presets - All sides
  static EdgeInsets get paddingNone => EdgeInsets.zero;
  static EdgeInsets get paddingXs => const EdgeInsets.all(xs);
  static EdgeInsets get paddingSm => const EdgeInsets.all(sm);
  static EdgeInsets get paddingMd => const EdgeInsets.all(md);
  static EdgeInsets get paddingLg => const EdgeInsets.all(lg);
  static EdgeInsets get paddingXl => const EdgeInsets.all(xl);

  // EdgeInsets presets - Horizontal
  static EdgeInsets get paddingHorizontalXs =>
      const EdgeInsets.symmetric(horizontal: xs);
  static EdgeInsets get paddingHorizontalSm =>
      const EdgeInsets.symmetric(horizontal: sm);
  static EdgeInsets get paddingHorizontalMd =>
      const EdgeInsets.symmetric(horizontal: md);
  static EdgeInsets get paddingHorizontalLg =>
      const EdgeInsets.symmetric(horizontal: lg);
  static EdgeInsets get paddingHorizontalXl =>
      const EdgeInsets.symmetric(horizontal: xl);

  // EdgeInsets presets - Vertical
  static EdgeInsets get paddingVerticalXs =>
      const EdgeInsets.symmetric(vertical: xs);
  static EdgeInsets get paddingVerticalSm =>
      const EdgeInsets.symmetric(vertical: sm);
  static EdgeInsets get paddingVerticalMd =>
      const EdgeInsets.symmetric(vertical: md);
  static EdgeInsets get paddingVerticalLg =>
      const EdgeInsets.symmetric(vertical: lg);
  static EdgeInsets get paddingVerticalXl =>
      const EdgeInsets.symmetric(vertical: xl);

  // Screen padding (with safe area consideration)
  static EdgeInsets get screenPaddingAll => const EdgeInsets.all(screenPadding);
  static EdgeInsets get screenPaddingHorizontal =>
      const EdgeInsets.symmetric(horizontal: screenPadding);

  // SizedBox presets - Horizontal gaps
  static SizedBox get horizontalGapXxs => const SizedBox(width: xxs);
  static SizedBox get horizontalGapXs => const SizedBox(width: xs);
  static SizedBox get horizontalGapSm => const SizedBox(width: sm);
  static SizedBox get horizontalGapMd => const SizedBox(width: md);
  static SizedBox get horizontalGapLg => const SizedBox(width: lg);
  static SizedBox get horizontalGapXl => const SizedBox(width: xl);

  // SizedBox presets - Vertical gaps
  static SizedBox get verticalGapXxs => const SizedBox(height: xxs);
  static SizedBox get verticalGapXs => const SizedBox(height: xs);
  static SizedBox get verticalGapSm => const SizedBox(height: sm);
  static SizedBox get verticalGapMd => const SizedBox(height: md);
  static SizedBox get verticalGapLg => const SizedBox(height: lg);
  static SizedBox get verticalGapXl => const SizedBox(height: xl);
  static SizedBox get verticalGapXxl => const SizedBox(height: xxl);
}

/// Extension for easy access to spacing from numbers
extension SpacingExtension on num {
  /// Convert to SizedBox with width
  SizedBox get horizontalSpace => SizedBox(width: toDouble());

  /// Convert to SizedBox with height
  SizedBox get verticalSpace => SizedBox(height: toDouble());

  /// Convert to EdgeInsets.all
  EdgeInsets get paddingAll => EdgeInsets.all(toDouble());

  /// Convert to EdgeInsets.symmetric(horizontal: this)
  EdgeInsets get paddingHorizontal =>
      EdgeInsets.symmetric(horizontal: toDouble());

  /// Convert to EdgeInsets.symmetric(vertical: this)
  EdgeInsets get paddingVertical => EdgeInsets.symmetric(vertical: toDouble());

  /// Convert to BorderRadius.circular
  BorderRadius get borderRadius => BorderRadius.circular(toDouble());
}
