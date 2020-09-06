//or provider of database and then you can create a mock database object and stop the jobs stream method to return a stream that you can configure from your test code.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'mocks.dart';

// Testing Navigation
// - Create a mockNavigatorObserver
// - Pass it to MaterialApp
// - verify that didPush() is called right after pumpWidget()
// - trigger navigation event in test
// - call pumpAndSettle
// - verify that didPush() is called

void main() {
  MockAuth mockAuth;
  MockNavigatorObserver mockNavigatorObserver;

  //initialize - new mock authentication service will be created every time
  setUp(() {
    mockAuth = MockAuth();
    mockNavigatorObserver = MockNavigatorObserver();
  });

//implemented this method we can use it to create and configure an email signing forms stateful widget
  Future<void> pumpEmailSignInPage(WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: MaterialApp(
          //User the Builder widget to get a context if needed
          home: Builder(
            builder: (context) => SignInPage.create(context),
          ),
          //check that navigation event has happened.
          navigatorObservers: [mockNavigatorObserver],
        ),
      ),
    );
    //twice called / 1. push EmailSignInPage
    verify(mockNavigatorObserver.didPush(any, any)).called(1);
  }

  testWidgets('email & password navigation', (WidgetTester tester) async {
    await pumpEmailSignInPage(tester);

    final emailSignInButton = find.byKey(SignInPage.emailPasswordKey);

    expect(emailSignInButton, findsOneWidget);

    await tester.tap(emailSignInButton);
    //wait for the navigation animation to complete
    await tester.pumpAndSettle();

    //twice called / 1. push EmailSignInPage 2. SignInPage first loaded
    verify(mockNavigatorObserver.didPush(any, any)).called(1);
  });
}
