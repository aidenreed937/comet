import 'package:flutter/material.dart';

/// Typography system for consistent text styling throughout the app.
/// Based on Material Design 3 type scale with customizations.
class AppTypography {
  AppTypography._();

  // Font family
  static const String fontFamily = 'Roboto';
  static const String fontFamilyMono = 'RobotoMono';

  // Font weights
  static const FontWeight thin = FontWeight.w100;
  static const FontWeight extraLight = FontWeight.w200;
  static const FontWeight light = FontWeight.w300;
  static const FontWeight regular = FontWeight.w400;
  static const FontWeight medium = FontWeight.w500;
  static const FontWeight semiBold = FontWeight.w600;
  static const FontWeight bold = FontWeight.w700;
  static const FontWeight extraBold = FontWeight.w800;
  static const FontWeight black = FontWeight.w900;

  // Line heights
  static const double lineHeightTight = 1.2;
  static const double lineHeightNormal = 1.5;
  static const double lineHeightRelaxed = 1.75;

  // Letter spacing
  static const double letterSpacingTight = -0.5;
  static const double letterSpacingNormal = 0;
  static const double letterSpacingWide = 0.5;
  static const double letterSpacingWider = 1;

  // Display styles - for large, short text like headlines
  static const TextStyle displayLarge = TextStyle(
    fontSize: 57,
    fontWeight: regular,
    letterSpacing: -0.25,
    height: lineHeightTight,
  );

  static const TextStyle displayMedium = TextStyle(
    fontSize: 45,
    fontWeight: regular,
    letterSpacing: 0,
    height: lineHeightTight,
  );

  static const TextStyle displaySmall = TextStyle(
    fontSize: 36,
    fontWeight: regular,
    letterSpacing: 0,
    height: lineHeightTight,
  );

  // Headline styles - for section headers
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 32,
    fontWeight: medium,
    letterSpacing: 0,
    height: lineHeightTight,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 28,
    fontWeight: medium,
    letterSpacing: 0,
    height: lineHeightTight,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontSize: 24,
    fontWeight: medium,
    letterSpacing: 0,
    height: lineHeightNormal,
  );

  // Title styles - for component titles
  static const TextStyle titleLarge = TextStyle(
    fontSize: 22,
    fontWeight: medium,
    letterSpacing: 0,
    height: lineHeightNormal,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: medium,
    letterSpacing: 0.15,
    height: lineHeightNormal,
  );

  static const TextStyle titleSmall = TextStyle(
    fontSize: 14,
    fontWeight: medium,
    letterSpacing: 0.1,
    height: lineHeightNormal,
  );

  // Body styles - for long-form content
  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: regular,
    letterSpacing: 0.5,
    height: lineHeightNormal,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: regular,
    letterSpacing: 0.25,
    height: lineHeightNormal,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: regular,
    letterSpacing: 0.4,
    height: lineHeightNormal,
  );

  // Label styles - for buttons, inputs, etc.
  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: medium,
    letterSpacing: 0.1,
    height: lineHeightNormal,
  );

  static const TextStyle labelMedium = TextStyle(
    fontSize: 12,
    fontWeight: medium,
    letterSpacing: 0.5,
    height: lineHeightNormal,
  );

  static const TextStyle labelSmall = TextStyle(
    fontSize: 11,
    fontWeight: medium,
    letterSpacing: 0.5,
    height: lineHeightNormal,
  );

  // Caption style
  static const TextStyle caption = TextStyle(
    fontSize: 12,
    fontWeight: regular,
    letterSpacing: 0.4,
    height: lineHeightNormal,
  );

  // Overline style
  static const TextStyle overline = TextStyle(
    fontSize: 10,
    fontWeight: medium,
    letterSpacing: 1.5,
    height: lineHeightNormal,
  );

  // Button text style
  static const TextStyle button = TextStyle(
    fontSize: 14,
    fontWeight: medium,
    letterSpacing: 0.5,
    height: lineHeightNormal,
  );

  // Code/monospace style
  static const TextStyle code = TextStyle(
    fontFamily: fontFamilyMono,
    fontSize: 14,
    fontWeight: regular,
    letterSpacing: 0,
    height: lineHeightRelaxed,
  );

  // Create TextTheme from our styles
  static TextTheme get textTheme => const TextTheme(
    displayLarge: displayLarge,
    displayMedium: displayMedium,
    displaySmall: displaySmall,
    headlineLarge: headlineLarge,
    headlineMedium: headlineMedium,
    headlineSmall: headlineSmall,
    titleLarge: titleLarge,
    titleMedium: titleMedium,
    titleSmall: titleSmall,
    bodyLarge: bodyLarge,
    bodyMedium: bodyMedium,
    bodySmall: bodySmall,
    labelLarge: labelLarge,
    labelMedium: labelMedium,
    labelSmall: labelSmall,
  );
}

/// Extension for TextStyle modifications
extension TextStyleExtension on TextStyle {
  /// Make the text bold
  TextStyle get bold => copyWith(fontWeight: FontWeight.bold);

  /// Make the text semi-bold
  TextStyle get semiBold => copyWith(fontWeight: FontWeight.w600);

  /// Make the text medium weight
  TextStyle get medium => copyWith(fontWeight: FontWeight.w500);

  /// Make the text italic
  TextStyle get italic => copyWith(fontStyle: FontStyle.italic);

  /// Underline the text
  TextStyle get underline => copyWith(decoration: TextDecoration.underline);

  /// Strike through the text
  TextStyle get lineThrough => copyWith(decoration: TextDecoration.lineThrough);

  /// Apply a color to the text
  TextStyle withColor(Color color) => copyWith(color: color);

  /// Apply a specific font size
  TextStyle withSize(double size) => copyWith(fontSize: size);

  /// Apply a specific line height
  TextStyle withHeight(double height) => copyWith(height: height);

  /// Apply letter spacing
  TextStyle withLetterSpacing(double spacing) =>
      copyWith(letterSpacing: spacing);
}
