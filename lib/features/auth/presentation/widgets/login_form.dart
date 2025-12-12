import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/l10n/l10n.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/validators/auth_validators.dart';
import '../providers/auth_providers.dart';

class LoginForm extends ConsumerWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final loginState = ref.watch(loginProvider);
    final formState = ref.watch(loginFormProvider);
    final isLoading = loginState is LoginLoading;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Email field
        _EmailField(
          value: formState.email,
          enabled: !isLoading,
          onChanged: ref.read(loginFormProvider.notifier).setEmail,
        ),
        const SizedBox(height: AppSpacing.md),

        // Password field
        _PasswordField(
          value: formState.password,
          obscureText: formState.obscurePassword,
          enabled: !isLoading,
          onChanged: ref.read(loginFormProvider.notifier).setPassword,
          onToggleVisibility:
              ref.read(loginFormProvider.notifier).togglePasswordVisibility,
          onSubmitted: () => _handleSubmit(ref, formState),
        ),
        const SizedBox(height: AppSpacing.sm),

        // Forgot password
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed:
                isLoading
                    ? null
                    : () {
                      // TODO(auth): Navigate to forgot password
                    },
            child: Text(l10n.forgotPassword),
          ),
        ),
        const SizedBox(height: AppSpacing.md),

        // Login button
        FilledButton(
          onPressed: isLoading ? null : () => _handleSubmit(ref, formState),
          child:
              isLoading
                  ? const SizedBox(
                    height: AppSpacing.iconSm,
                    width: AppSpacing.iconSm,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                  : Text(l10n.login),
        ),
        const SizedBox(height: AppSpacing.md),

        // Sign up link
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(l10n.noAccount, style: theme.textTheme.bodyMedium),
            TextButton(
              onPressed:
                  isLoading
                      ? null
                      : () {
                        // TODO(auth): Navigate to sign up
                      },
              child: Text(l10n.signUp),
            ),
          ],
        ),
      ],
    );
  }

  void _handleSubmit(WidgetRef ref, LoginFormState formState) {
    final emailError = AuthValidators.validateEmail(formState.email);
    final passwordError = AuthValidators.validatePassword(formState.password);

    if (emailError != null || passwordError != null) {
      return;
    }

    ref
        .read(loginProvider.notifier)
        .login(email: formState.email.trim(), password: formState.password);
  }
}

/// Email input field widget
class _EmailField extends ConsumerWidget {
  const _EmailField({
    required this.value,
    required this.enabled,
    required this.onChanged,
  });

  final String value;
  final bool enabled;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final error = value.isEmpty ? null : AuthValidators.validateEmail(value);

    return TextFormField(
      initialValue: value,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: l10n.email,
        hintText: l10n.emailHint,
        prefixIcon: const Icon(Icons.email_outlined),
        errorText: switch (error) {
          EmailValidationError.required => l10n.emailRequired,
          EmailValidationError.invalidFormat => l10n.emailInvalid,
          null => null,
        },
      ),
      onChanged: onChanged,
    );
  }
}

/// Password input field widget
class _PasswordField extends ConsumerWidget {
  const _PasswordField({
    required this.value,
    required this.obscureText,
    required this.enabled,
    required this.onChanged,
    required this.onToggleVisibility,
    required this.onSubmitted,
  });

  final String value;
  final bool obscureText;
  final bool enabled;
  final ValueChanged<String> onChanged;
  final VoidCallback onToggleVisibility;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = context.l10n;
    final error = value.isEmpty ? null : AuthValidators.validatePassword(value);

    return TextFormField(
      initialValue: value,
      obscureText: obscureText,
      textInputAction: TextInputAction.done,
      enabled: enabled,
      onFieldSubmitted: (_) => onSubmitted(),
      decoration: InputDecoration(
        labelText: l10n.password,
        hintText: l10n.passwordHint,
        prefixIcon: const Icon(Icons.lock_outlined),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
          ),
          onPressed: onToggleVisibility,
        ),
        errorText: switch (error) {
          PasswordValidationError.required => l10n.passwordRequired,
          PasswordValidationError.tooShort => l10n.passwordTooShort,
          null => null,
        },
      ),
      onChanged: onChanged,
    );
  }
}
