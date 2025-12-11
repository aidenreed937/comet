import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// Snackbar type for different visual styles
enum SnackBarType {
  info,
  success,
  warning,
  error,
}

/// A utility class for showing styled snackbars
class AppSnackBar {
  AppSnackBar._();

  /// Show a snackbar with the specified type
  static void show(
    BuildContext context, {
    required String message,
    SnackBarType type = SnackBarType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
    bool showCloseIcon = false,
  }) {
    final snackBar = _buildSnackBar(
      context,
      message: message,
      type: type,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
      showCloseIcon: showCloseIcon,
    );

    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(snackBar);
  }

  /// Show an info snackbar
  static void info(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context,
      message: message,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Show a success snackbar
  static void success(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.success,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Show a warning snackbar
  static void warning(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.warning,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Show an error snackbar
  static void error(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 4),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    show(
      context,
      message: message,
      type: SnackBarType.error,
      duration: duration,
      actionLabel: actionLabel,
      onAction: onAction,
    );
  }

  /// Hide the current snackbar
  static void hide(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }

  /// Clear all snackbars
  static void clearAll(BuildContext context) {
    ScaffoldMessenger.of(context).clearSnackBars();
  }

  static SnackBar _buildSnackBar(
    BuildContext context, {
    required String message,
    required SnackBarType type,
    required Duration duration,
    String? actionLabel,
    VoidCallback? onAction,
    bool showCloseIcon = false,
  }) {
    final colors = _getColors(context, type);

    return SnackBar(
      content: Row(
        children: [
          Icon(
            _getIcon(type),
            color: colors.foreground,
            size: AppSpacing.iconSm,
          ),
          AppSpacing.horizontalGapSm,
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: colors.foreground,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: colors.background,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusSm,
      ),
      margin: AppSpacing.paddingMd,
      showCloseIcon: showCloseIcon,
      closeIconColor: colors.foreground,
      action: actionLabel != null && onAction != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: colors.foreground,
              onPressed: onAction,
            )
          : null,
    );
  }

  static IconData _getIcon(SnackBarType type) {
    return switch (type) {
      SnackBarType.info => Icons.info_outline,
      SnackBarType.success => Icons.check_circle_outline,
      SnackBarType.warning => Icons.warning_amber_outlined,
      SnackBarType.error => Icons.error_outline,
    };
  }

  static ({Color background, Color foreground}) _getColors(
    BuildContext context,
    SnackBarType type,
  ) {
    final isDark = context.isDarkMode;

    return switch (type) {
      SnackBarType.info => (
          background: isDark ? AppColors.dark.infoBackground : AppColors.info,
          foreground: isDark ? AppColors.info : AppColors.white,
        ),
      SnackBarType.success => (
          background:
              isDark ? AppColors.dark.successBackground : AppColors.success,
          foreground: isDark ? AppColors.success : AppColors.white,
        ),
      SnackBarType.warning => (
          background:
              isDark ? AppColors.dark.warningBackground : AppColors.warning,
          foreground: isDark ? AppColors.warning : AppColors.white,
        ),
      SnackBarType.error => (
          background: isDark ? AppColors.dark.errorBackground : AppColors.error,
          foreground: isDark ? AppColors.error : AppColors.white,
        ),
    };
  }
}
