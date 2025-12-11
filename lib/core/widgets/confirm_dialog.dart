import 'package:flutter/material.dart';

import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

/// A customizable confirmation dialog with cancel and confirm actions.
class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    required this.title,
    super.key,
    this.content,
    this.contentWidget,
    this.cancelText = 'Cancel',
    this.confirmText = 'Confirm',
    this.isDestructive = false,
    this.onCancel,
    this.onConfirm,
  });

  /// Dialog title
  final String title;

  /// Text content (mutually exclusive with contentWidget)
  final String? content;

  /// Custom content widget (overrides content)
  final Widget? contentWidget;

  /// Cancel button text
  final String cancelText;

  /// Confirm button text
  final String confirmText;

  /// Whether the action is destructive (changes confirm button to red)
  final bool isDestructive;

  /// Callback when cancel is pressed (defaults to popping with false)
  final VoidCallback? onCancel;

  /// Callback when confirm is pressed (defaults to popping with true)
  final VoidCallback? onConfirm;

  /// Show the dialog and return true if confirmed, false otherwise
  static Future<bool?> show(
    BuildContext context, {
    required String title,
    String? content,
    Widget? contentWidget,
    String cancelText = 'Cancel',
    String confirmText = 'Confirm',
    bool isDestructive = false,
    bool barrierDismissible = true,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder:
          (context) => ConfirmDialog(
            title: title,
            content: content,
            contentWidget: contentWidget,
            cancelText: cancelText,
            confirmText: confirmText,
            isDestructive: isDestructive,
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      title: Text(title, style: AppTypography.titleLarge),
      content: _buildContent(theme),
      shape: RoundedRectangleBorder(borderRadius: AppSpacing.borderRadiusMd),
      actionsPadding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.md,
      ),
      actions: [
        TextButton(
          onPressed: () {
            if (onCancel != null) {
              onCancel!();
            } else {
              Navigator.of(context).pop(false);
            }
          },
          child: Text(cancelText),
        ),
        FilledButton(
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!();
            } else {
              Navigator.of(context).pop(true);
            }
          },
          style:
              isDestructive
                  ? FilledButton.styleFrom(
                    backgroundColor: theme.colorScheme.error,
                    foregroundColor: theme.colorScheme.onError,
                  )
                  : null,
          child: Text(confirmText),
        ),
      ],
    );
  }

  Widget? _buildContent(ThemeData theme) {
    if (contentWidget != null) return contentWidget;
    if (content == null) return null;

    return Text(
      content!,
      style: AppTypography.bodyMedium.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}

/// Convenient methods for common confirm dialogs
class ConfirmDialogHelper {
  ConfirmDialogHelper._();

  /// Show a delete confirmation dialog
  static Future<bool?> delete(
    BuildContext context, {
    String title = 'Delete Item',
    String content =
        'Are you sure you want to delete this item? This action cannot be undone.',
    String cancelText = 'Cancel',
    String confirmText = 'Delete',
  }) {
    return ConfirmDialog.show(
      context,
      title: title,
      content: content,
      cancelText: cancelText,
      confirmText: confirmText,
      isDestructive: true,
    );
  }

  /// Show a logout confirmation dialog
  static Future<bool?> logout(
    BuildContext context, {
    String title = 'Log Out',
    String content = 'Are you sure you want to log out?',
    String cancelText = 'Cancel',
    String confirmText = 'Log Out',
  }) {
    return ConfirmDialog.show(
      context,
      title: title,
      content: content,
      cancelText: cancelText,
      confirmText: confirmText,
    );
  }

  /// Show a discard changes confirmation dialog
  static Future<bool?> discardChanges(
    BuildContext context, {
    String title = 'Discard Changes',
    String content =
        'You have unsaved changes. Are you sure you want to discard them?',
    String cancelText = 'Keep Editing',
    String confirmText = 'Discard',
  }) {
    return ConfirmDialog.show(
      context,
      title: title,
      content: content,
      cancelText: cancelText,
      confirmText: confirmText,
      isDestructive: true,
    );
  }
}
