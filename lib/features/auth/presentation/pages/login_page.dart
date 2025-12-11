import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/auth_providers.dart';
import '../providers/login_state.dart';
import '../widgets/login_form.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);

    ref.listen<LoginState>(loginProvider, (previous, next) {
      if (next is LoginSuccess) {
        AppSnackBar.success(context, message: l10n.loginSuccess);
        // TODO(auth): Navigate to home
      } else if (next is LoginFailure) {
        AppSnackBar.error(context, message: next.message);
      }
    });

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo or App Name
                const Icon(
                  Icons.lock_outline,
                  size: 80,
                  color: Color(0xFF6750A4),
                ),
                const SizedBox(height: 40),
                Text(
                  l10n.loginTitle,
                  style: theme.textTheme.displaySmall,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.loginSubtitle,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                const LoginForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
