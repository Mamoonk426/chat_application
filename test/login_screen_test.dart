// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:chat_application/providers/loginProvider.dart';
import 'package:chat_application/view/loginScreen.dart';
import 'package:chat_application/view/homeScreen.dart';
import 'package:chat_application/view/registerScreen.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Fake Provider
//
// Extends Loginprovider so it satisfies Provider.of<Loginprovider>().
// Override any additional Loginprovider methods your real class requires.
// ─────────────────────────────────────────────────────────────────────────────

class FakeLoginProvider extends Loginprovider {
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  bool? _loginResult;

  // Introspection helpers (read in tests)
  String? capturedEmail;
  String? capturedPassword;
  int loginCallCount = 0;

  void stubLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void stubLoginResult(bool? result) => _loginResult = result;

  // ── Loginprovider contract ─────────────────────────────────────────────────

  @override
  bool get isLoading => _isLoading;

  @override
  bool get ispasswordVisible => _isPasswordVisible;

  @override
  void setPasswordVisibility(bool val) {
    _isPasswordVisible = val;
    notifyListeners();
  }

  @override
  Future<bool> login(
    String email,
    String password,
    BuildContext context,
  ) async {
    capturedEmail = email;
    capturedPassword = password;
    loginCallCount++;
    return _loginResult ?? false;
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper: wrap Loginscreen with its required Provider + MaterialApp
// ─────────────────────────────────────────────────────────────────────────────

Widget buildSubject(FakeLoginProvider provider) {
  return MaterialApp(
    home: ChangeNotifierProvider<Loginprovider>.value(
      value: provider,
      child: const Loginscreen(),
    ),
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// Tests
// ─────────────────────────────────────────────────────────────────────────────

void main() {
  late FakeLoginProvider provider;

  setUp(() {
    provider = FakeLoginProvider();
  });

  // ── Group 1: Rendering ────────────────────────────────────────────────────

  group('Rendering', () {
    testWidgets('TC-01 shows Welcome Back heading and subtitle', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject(provider));

      expect(find.text('Welcome Back'), findsOneWidget);
      expect(
        find.text('Sign in to continue your conversations'),
        findsOneWidget,
      );
    });

    testWidgets(
      'TC-02 renders email field, password field, and Sign In button',
      (tester) async {
        await tester.pumpWidget(buildSubject(provider));

        // Two TextFields should exist: email (index 0) and password (index 1)
        expect(find.byType(TextField), findsNWidgets(2));
        expect(find.text('Sign In'), findsOneWidget);
      },
    );

    testWidgets('TC-03 renders chat bubble icon', (tester) async {
      await tester.pumpWidget(buildSubject(provider));

      expect(find.byIcon(Icons.chat_bubble_rounded), findsOneWidget);
    });

    testWidgets('TC-04 renders Register Now link', (tester) async {
      await tester.pumpWidget(buildSubject(provider));

      expect(find.text("Don't have an account? "), findsOneWidget);
      expect(find.text('Register Now'), findsOneWidget);
    });
  });

  // ── Group 2: Input fields ─────────────────────────────────────────────────

  group('Input fields', () {
    testWidgets('TC-05 email field accepts and displays typed text', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject(provider));

      await tester.enterText(
        find.byType(TextField).first,
        'mamoon@example.com',
      );

      expect(find.text('mamoon@example.com'), findsOneWidget);
    });

    testWidgets('TC-06 password field accepts typed text', (tester) async {
      await tester.pumpWidget(buildSubject(provider));

      await tester.enterText(find.byType(TextField).last, 'mySecret123');

      // Text is present in the controller even when obscured
      final tf = tester.widget<TextField>(find.byType(TextField).last);
      expect(tf.controller?.text, 'mySecret123');
    });
  });

  // ── Group 3: Password visibility ──────────────────────────────────────────

  group('Password visibility toggle', () {
    testWidgets('TC-07 password is obscured by default', (tester) async {
      await tester.pumpWidget(buildSubject(provider));

      expect(provider.ispasswordVisible, isFalse);

      final tf = tester.widget<TextField>(find.byType(TextField).last);
      // isObscure maps to obscureText on the underlying TextField
      expect(tf.obscureText, isTrue);
    });

    testWidgets('TC-08 tapping eye icon calls setPasswordVisibility(true)', (
      tester,
    ) async {
      await tester.pumpWidget(buildSubject(provider));

      // The suffix IconButton is the visibility toggle
      await tester.tap(find.byType(IconButton));
      await tester.pump();

      expect(provider.ispasswordVisible, isTrue);
    });

    testWidgets(
      'TC-09 eye icon reflects visibility state (off icon when visible)',
      (tester) async {
        provider.setPasswordVisibility(true);
        await tester.pumpWidget(buildSubject(provider));

        expect(find.byIcon(Icons.visibility_off_rounded), findsOneWidget);
      },
    );

    testWidgets(
      'TC-10 eye icon shows visibility_rounded when password is hidden',
      (tester) async {
        await tester.pumpWidget(buildSubject(provider));

        expect(find.byIcon(Icons.visibility_rounded), findsOneWidget);
      },
    );
  });

  // ── Group 4: Sign In button ───────────────────────────────────────────────

  group('Sign In button', () {
    testWidgets('TC-11 shows loading indicator when isLoading is true', (
      tester,
    ) async {
      provider.stubLoading(true);
      await tester.pumpWidget(buildSubject(provider));

      // Assumes your Button widget renders a CircularProgressIndicator
      // while isLoading is true. Adjust the finder if it uses a different widget.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('TC-12 calls login() with trimmed email and password', (
      tester,
    ) async {
      provider.stubLoginResult(false);
      await tester.pumpWidget(buildSubject(provider));

      await tester.enterText(
        find.byType(TextField).first,
        '  mamoon@example.com  ',
      );
      await tester.enterText(find.byType(TextField).last, '  pass123  ');

      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(provider.capturedEmail, 'mamoon@example.com');
      expect(provider.capturedPassword, 'pass123');
      expect(provider.loginCallCount, 1);
    });

    testWidgets('TC-13 login() is called exactly once per tap', (tester) async {
      provider.stubLoginResult(false);
      await tester.pumpWidget(buildSubject(provider));

      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(provider.loginCallCount, equals(1));
    });
  });

  // ── Group 5: Navigation ───────────────────────────────────────────────────

  group('Navigation', () {
    testWidgets('TC-14 navigates to Homescreen when login returns true', (
      tester,
    ) async {
      provider.stubLoginResult(true);
      await tester.pumpWidget(buildSubject(provider));

      await tester.enterText(find.byType(TextField).first, 'user@example.com');
      await tester.enterText(find.byType(TextField).last, 'password123');

      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.byType(Homescreen), findsOneWidget);
      expect(find.byType(Loginscreen), findsNothing);
    });

    testWidgets('TC-15 stays on Loginscreen when login returns false', (
      tester,
    ) async {
      provider.stubLoginResult(false);
      await tester.pumpWidget(buildSubject(provider));

      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.byType(Loginscreen), findsOneWidget);
      expect(find.byType(Homescreen), findsNothing);
    });

    testWidgets('TC-16 stays on Loginscreen when login returns null', (
      tester,
    ) async {
      provider.stubLoginResult(null);
      await tester.pumpWidget(buildSubject(provider));

      await tester.tap(find.text('Sign In'));
      await tester.pumpAndSettle();

      expect(find.byType(Loginscreen), findsOneWidget);
      expect(find.byType(Homescreen), findsNothing);
    });

    testWidgets(
      'TC-17 tapping Register Now replaces route with Registerscreen',
      (tester) async {
        await tester.pumpWidget(buildSubject(provider));

        await tester.tap(find.text('Register Now'));
        await tester.pumpAndSettle();

        expect(find.byType(Registerscreen), findsOneWidget);
        expect(find.byType(Loginscreen), findsNothing);
      },
    );
  });
}
