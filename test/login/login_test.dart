import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:send_money_app/components.dart';
import 'package:send_money_app/screens.dart';
import 'package:send_money_app/services.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

import 'login_test.mocks.dart';

@GenerateMocks([AuthService])
void main() {
  const loaderKey = ValueKey('loaderKey');
  final valueKey = loaderKey.value;

  const loginScreenKey = Key('LoginScreenKey');

  testWidgets('Successful login navigates to WalletScreen',
      (WidgetTester tester) async {
    final mockAuthService = MockAuthService();
    when(mockAuthService.login('username', 'password123'))
        .thenAnswer((_) async => true);

    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(
          key: loginScreenKey,
          valueKey: loaderKey,
          authService: mockAuthService,
        ),
      ),
    );

    final loginUsernameTextFieldFinder =
        find.byKey(Key('$valueKey-login_username_text_field'));
    expect(loginUsernameTextFieldFinder, findsOneWidget);

    final loginPasswordTextFieldFinder =
        find.byKey(Key('$valueKey-login_password_text_field'));
    expect(loginPasswordTextFieldFinder, findsOneWidget);

    final loginCustomButtonFinder = find.byType(CustomButton);
    expect(loginCustomButtonFinder, findsOneWidget);

    await tester.enterText(loginUsernameTextFieldFinder, 'username');
    await tester.enterText(loginPasswordTextFieldFinder, 'password123');

    await tester.tap(loginCustomButtonFinder);
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    expect(find.byType(WalletScreen), findsOneWidget);
  });

  testWidgets('Failed login shows Snackbar', (WidgetTester tester) async {
    final mockAuthService = MockAuthService();
    when(mockAuthService.login('user', 'password'))
        .thenAnswer((_) async => false);

    await tester.pumpWidget(
      MaterialApp(
        home: LoginScreen(
          key: loginScreenKey,
          valueKey: loaderKey,
          authService: mockAuthService,
        ),
      ),
    );

    final loginUsernameTextFieldFinder =
        find.byKey(Key('$valueKey-login_username_text_field'));
    expect(loginUsernameTextFieldFinder, findsOneWidget);

    final loginPasswordTextFieldFinder =
        find.byKey(Key('$valueKey-login_password_text_field'));
    expect(loginPasswordTextFieldFinder, findsOneWidget);

    final loginCustomButtonFinder = find.byType(CustomButton);
    expect(loginCustomButtonFinder, findsOneWidget);

    await tester.enterText(loginUsernameTextFieldFinder, 'user');
    await tester.enterText(loginPasswordTextFieldFinder, 'password');

    await tester.tap(loginCustomButtonFinder);
    await tester.pumpAndSettle(const Duration(milliseconds: 500));

    expect(find.text('The username or password you entered is incorrect.'),
        findsOneWidget);
  });
}
