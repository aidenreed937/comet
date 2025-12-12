import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/widgets/widgets.dart';
import '../providers/auth_providers.dart';
import '../widgets/login_view.dart';

/// Login page - pure container handling state listeners and scaffold.
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;

    ref.listen<LoginState>(loginProvider, (previous, next) {
      if (next is LoginSuccess) {
        AppSnackBar.success(context, message: l10n.loginSuccess);
        // TODO(auth): Navigate to home
      } else if (next is LoginFailure) {
        AppSnackBar.error(context, message: next.message);
      }
    });

    return const Scaffold(
      body: SafeArea(
        child: LoginView(),
      ),
    );
  }
}
