import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/home_page.dart';
import 'package:time_tracker_flutter_course/app/landing_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'mocks.dart';

void main() {
  MockAuth mockAuth;
  StreamController<User> authStateChangesController;

  //new mock authentication service will be created every time
  setUp(() {
    mockAuth = MockAuth();
    authStateChangesController = StreamController<User>();
  });

  //Remeber to close StreamControllers in tearDown() end of each test
  tearDown(() {
    authStateChangesController.close();
  });

//implemented this method we can use it to create and configure an email signing forms stateful widget
  Future<void> pumpLandingPage(WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<AuthBase>(
        create: (_) => mockAuth,
        child: MaterialApp(
          home: LandingPage(),
        ),
      ),
    );
    //Widget state changes ➡ tester.pump();
    await tester.pump();
  }

  //iterable(반복) is a useful method of the stream
  void stubAuthStateChangesYields(Iterable<User> authStateChanges) {
    authStateChangesController.addStream(
      Stream<User>.fromIterable(authStateChanges),
    );
    when(mockAuth.authStateChanges).thenAnswer((_) {
      return authStateChangesController.stream;
    });
  }

  testWidgets('stream waiting', (WidgetTester tester) async {
    stubAuthStateChangesYields([]);

    await pumpLandingPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('null user', (WidgetTester tester) async {
    stubAuthStateChangesYields([null]);

    await pumpLandingPage(tester);

    expect(find.byType(SignInPage), findsOneWidget);
  });

  testWidgets('non null user', (WidgetTester tester) async {
    stubAuthStateChangesYields([User(uid: '123')]);

    await pumpLandingPage(tester);

    expect(find.byType(HomePage), findsOneWidget);
  });
}
