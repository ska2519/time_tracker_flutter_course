import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_manager.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'mocks.dart';

//create mock ValueNotifier that records all the values inside the list
//reuse mock value notifier it's useful
class MockValueNotifier<T> extends ValueNotifier<T> {
  MockValueNotifier(T value) : super(value);

  List<T> values = [];

  //void return type that we don't need. delete void
  //addition to setting the value to super we also added to the list of values.
  @override
  set value(T newValue) {
    values.add(newValue);
    super.value = newValue;
  }
}

void main() {
  MockAuth mockAuth;
  //ValueNotifier<bool> isLoading; /changed by Mock
  MockValueNotifier<bool> isLoading;
  // declare
  SignInManager manager;

  setUp(() {
    mockAuth = MockAuth();
    //isLoading = ValueNotifier<bool>(false); /changed by Mock
    isLoading = MockValueNotifier<bool>(false);
    manager = SignInManager(auth: mockAuth, isLoading: isLoading);
  });

  test('sign-in - success', () async {
    //thenAnswer((_) - this gives us a closure with any location
    when(mockAuth.signInAnonymously()).thenAnswer(
      (_) => Future.value(User(uid: '123')),
    );
    await manager.signInAnonymously();

    expect(isLoading.values, [true]);
  });

  test('sign-in - failure', () async {
    //thenAnswer((_) - this gives us a closure with any location
    when(mockAuth.signInAnonymously()).thenThrow(
      PlatformException(code: 'ERROR', message: 'sign-in-failed'),
    );
    try {
      await manager.signInAnonymously();
    } catch (e) {
      expect(isLoading.values, [true, false]);
    }
  });
}
