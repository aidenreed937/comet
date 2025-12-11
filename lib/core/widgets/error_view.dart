import 'package:flutter/material.dart';

import '../error/failure.dart';

class ErrorView extends StatelessWidget {
  const ErrorView({
    required this.failure,
    super.key,
    this.onRetry,
    this.retryText = 'Retry',
  });

  final Failure failure;
  final VoidCallback? onRetry;
  final String retryText;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getIcon(),
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              _getTitle(),
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              failure.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: Text(retryText),
              ),
            ],
          ],
        ),
      ),
    );
  }

  IconData _getIcon() {
    return switch (failure.type) {
      FailureType.network => Icons.wifi_off,
      FailureType.server => Icons.cloud_off,
      FailureType.authentication => Icons.lock,
      FailureType.authorization => Icons.no_accounts,
      FailureType.notFound => Icons.search_off,
      _ => Icons.error_outline,
    };
  }

  String _getTitle() {
    return switch (failure.type) {
      FailureType.network => 'Connection Error',
      FailureType.server => 'Server Error',
      FailureType.authentication => 'Authentication Required',
      FailureType.authorization => 'Access Denied',
      FailureType.notFound => 'Not Found',
      _ => 'Error',
    };
  }
}
