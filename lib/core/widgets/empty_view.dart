import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// A widget that displays an empty state with an icon, title, and optional action.
class EmptyView extends StatelessWidget {
  const EmptyView({
    required this.title,
    super.key,
    this.subtitle,
    this.icon,
    this.iconData,
    this.iconSize = 64,
    this.iconColor,
    this.action,
    this.actionText,
    this.onAction,
  }) : assert(
         icon == null || iconData == null,
         'Cannot provide both icon and iconData',
       );

  /// The main title text
  final String title;

  /// Optional subtitle text
  final String? subtitle;

  /// Custom icon widget (mutually exclusive with iconData)
  final Widget? icon;

  /// Icon data for default icon (mutually exclusive with icon)
  final IconData? iconData;

  /// Size of the icon
  final double iconSize;

  /// Color of the icon (defaults to theme's secondary color)
  final Color? iconColor;

  /// Custom action widget (overrides actionText and onAction)
  final Widget? action;

  /// Text for the action button
  final String? actionText;

  /// Callback when action button is pressed
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = context.isDarkMode;

    return Center(
      child: Padding(
        padding: AppSpacing.paddingLg,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildIcon(isDark),
            AppSpacing.verticalGapMd,
            _buildTitle(theme),
            if (subtitle != null) ...[
              AppSpacing.verticalGapSm,
              _buildSubtitle(isDark),
            ],
            if (action != null || (actionText != null && onAction != null)) ...[
              AppSpacing.verticalGapLg,
              _buildAction(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildIcon(bool isDark) {
    if (icon != null) return icon!;

    final defaultColor =
        isDark ? AppColors.dark.textTertiary : AppColors.light.textTertiary;

    return Icon(
      iconData ?? Icons.inbox_outlined,
      size: iconSize,
      color: iconColor ?? defaultColor,
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Text(
      title,
      style: AppTypography.titleMedium.copyWith(
        color: theme.colorScheme.onSurface,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildSubtitle(bool isDark) {
    final textColor =
        isDark ? AppColors.dark.textSecondary : AppColors.light.textSecondary;

    return Text(
      subtitle!,
      style: AppTypography.bodyMedium.copyWith(color: textColor),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildAction() {
    if (action != null) return action!;

    return FilledButton(onPressed: onAction, child: Text(actionText!));
  }
}

/// Predefined empty view variants
class EmptyViewVariants {
  EmptyViewVariants._();

  /// Empty list state
  static EmptyView noData({
    String title = 'No Data',
    String? subtitle = 'There is nothing to show here.',
    String? actionText,
    VoidCallback? onAction,
  }) {
    return EmptyView(
      title: title,
      subtitle: subtitle,
      iconData: Icons.inbox_outlined,
      actionText: actionText,
      onAction: onAction,
    );
  }

  /// No search results
  static EmptyView noResults({
    String title = 'No Results',
    String? subtitle = 'Try adjusting your search criteria.',
    String? actionText,
    VoidCallback? onAction,
  }) {
    return EmptyView(
      title: title,
      subtitle: subtitle,
      iconData: Icons.search_off_outlined,
      actionText: actionText,
      onAction: onAction,
    );
  }

  /// Network error state
  static EmptyView networkError({
    String title = 'No Connection',
    String subtitle = 'Please check your internet connection.',
    String actionText = 'Retry',
    VoidCallback? onAction,
  }) {
    return EmptyView(
      title: title,
      subtitle: subtitle,
      iconData: Icons.wifi_off_outlined,
      actionText: actionText,
      onAction: onAction,
    );
  }

  /// Generic error state
  static EmptyView error({
    String title = 'Something Went Wrong',
    String subtitle = 'An unexpected error occurred.',
    String actionText = 'Try Again',
    VoidCallback? onAction,
  }) {
    return EmptyView(
      title: title,
      subtitle: subtitle,
      iconData: Icons.error_outline,
      actionText: actionText,
      onAction: onAction,
    );
  }
}
