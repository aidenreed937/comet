import 'package:comet/app/bootstrap.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

/// Integration test for login flow
///
/// This test demonstrates how to use integration_test package
/// (the official replacement for flutter_driver) to test user flows.
///
/// Run this test with:
/// ```bash
/// flutter test integration_test/login_flow_test.dart
/// ```
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Login Flow Integration Tests', () {
    testWidgets('should display login page on app start',
        (WidgetTester tester) async {
      // Start the app
      await bootstrap(environment: 'development');
      await tester.pumpAndSettle();

      // Verify login page is displayed
      expect(find.text('欢迎回来'), findsOneWidget);
      expect(find.text('登录以继续'), findsOneWidget);
      expect(find.byType(TextFormField), findsNWidgets(2));
      expect(find.text('登录'), findsOneWidget);
    });

    testWidgets('should show validation errors for empty fields',
        (WidgetTester tester) async {
      // Start the app
      await bootstrap(environment: 'development');
      await tester.pumpAndSettle();

      // Find and tap the login button without entering any data
      final loginButton = find.widgetWithText(FilledButton, '登录');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify validation error messages are displayed
      expect(find.text('请输入邮箱'), findsOneWidget);
      expect(find.text('请输入密码'), findsOneWidget);
    });

    testWidgets('should show validation error for invalid email',
        (WidgetTester tester) async {
      // Start the app
      await bootstrap(environment: 'development');
      await tester.pumpAndSettle();

      // Find email field and enter invalid email
      final emailField = find.widgetWithText(TextFormField, '邮箱').first;
      await tester.enterText(emailField, 'invalid-email');
      await tester.pumpAndSettle();

      // Find and tap the login button
      final loginButton = find.widgetWithText(FilledButton, '登录');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify email validation error is displayed
      expect(find.text('请输入有效的邮箱地址'), findsOneWidget);
    });

    testWidgets('should show validation error for short password',
        (WidgetTester tester) async {
      // Start the app
      await bootstrap(environment: 'development');
      await tester.pumpAndSettle();

      // Find and fill email field with valid email
      final emailField = find.widgetWithText(TextFormField, '邮箱').first;
      await tester.enterText(emailField, 'test@example.com');
      await tester.pumpAndSettle();

      // Find and fill password field with short password
      final passwordField = find.widgetWithText(TextFormField, '密码').first;
      await tester.enterText(passwordField, '123');
      await tester.pumpAndSettle();

      // Find and tap the login button
      final loginButton = find.widgetWithText(FilledButton, '登录');
      await tester.tap(loginButton);
      await tester.pumpAndSettle();

      // Verify password length validation error is displayed
      expect(find.text('密码长度不能少于6位'), findsOneWidget);
    });

    testWidgets('should toggle password visibility',
        (WidgetTester tester) async {
      // Start the app
      await bootstrap(environment: 'development');
      await tester.pumpAndSettle();

      // Find password field
      final passwordField = find.widgetWithText(TextFormField, '密码').first;
      await tester.enterText(passwordField, 'password123');
      await tester.pumpAndSettle();

      // Verify password field exists
      expect(passwordField, findsOneWidget);

      // Find and tap the visibility toggle button (IconButton in password field)
      final visibilityToggle = find.byType(IconButton).last;
      expect(visibilityToggle, findsOneWidget);

      // Tap to toggle visibility
      await tester.tap(visibilityToggle);
      await tester.pumpAndSettle();

      // Tap again to toggle back
      await tester.tap(visibilityToggle);
      await tester.pumpAndSettle();

      // Verify the toggle button still works (no exceptions thrown)
      expect(visibilityToggle, findsOneWidget);
    });

    testWidgets('should navigate to forgot password page',
        (WidgetTester tester) async {
      // Start the app
      await bootstrap(environment: 'development');
      await tester.pumpAndSettle();

      // Find and tap "忘记密码？" button
      final forgotPasswordButton = find.text('忘记密码？');
      expect(forgotPasswordButton, findsOneWidget);

      // TODO(auth): Implement forgot password navigation test
      // after forgot password page is implemented
    });

    testWidgets('should navigate to sign up page', (WidgetTester tester) async {
      // Start the app
      await bootstrap(environment: 'development');
      await tester.pumpAndSettle();

      // Find and tap "注册" button
      final signUpButton = find.text('注册');
      expect(signUpButton, findsOneWidget);

      // TODO(auth): Implement sign up navigation test
      // after sign up page is implemented
    });
  });
}
