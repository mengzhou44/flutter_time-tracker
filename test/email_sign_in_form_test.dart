import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_time_tracker/app/sign-in/email-sign-in-bloc.dart';
import 'package:flutter_time_tracker/app/sign-in/email-sign-in-form.dart';

import 'package:flutter_time_tracker/services/auth.dart';

import 'package:provider/provider.dart';

import 'mocks.dart';

void main() {
  MockAuth mockAuth;
  EmailSignInBloc bloc;

  setUp(() {
    mockAuth = MockAuth();
    bloc = EmailSignInBloc(auth: mockAuth);
  });

  Future<void> pumpEmailSignInForm(WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        builder: (_) => mockAuth,
        child: MaterialApp(
          home: Scaffold(body: EmailSignInForm(
             bloc: bloc,
          )),
        ),
      ),
    );
  }



  group('sign in', () {
    testWidgets(
        'WHEN user doesn\'t enter the email and password'
        'AND user taps on the sign-in button'
        'THEN signInWithEmailAndPassword is not called'
        , (WidgetTester tester) async {

      await pumpEmailSignInForm(tester);

      // final signInButton = find.text('Sign in');
      // await tester.tap(signInButton);

      // verifyNever(mockAuth.signInWithEmailAndPassword(any, any));
    
    });
  });
}
