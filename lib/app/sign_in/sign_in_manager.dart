import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInManager {
  SignInManager({@required this.auth, @required this.isLoading});
  final AuthBase auth;
  final ValueNotifier<bool> isLoading;

/*
  // ValueNotifier 로 StreamController + stream 대체
  final StreamController<bool> _isLoadingController = StreamController<bool>();
  Stream<bool> get isLoadingStream => _isLoadingController.stream;

  //sign in 페이지를 사용하지 않을 때 bloc 폐기 /bloc 폐기 후 value 추가 ㄴㄴ
  void dispose() => _isLoadingController.close();

  //sign in 페이지에서 setLoading 실행 시 스트림에 전달 하는 컨트롤러 동기화와 변수(isLoading) 추가
  void _setIsLoading(bool isLoading) => _isLoadingController.add(isLoading);
*/

  //Future<User> 대한 Function을 인자로 반환하는 함수를 전달하는 것입니다.
  Future<User> _signIn(Future<User> Function() signInMethod) async {
    try {
      isLoading.value = true;
      return await signInMethod();
    } catch (e) {
      isLoading.value = false;
      // 호출 코드까지 예외를 전달하는 방법
      rethrow;
    }
  }

  Future<User> signInAnonymously() async =>
      await _signIn(auth.signInAnonymously);

  Future<User> signInWithGoogle() async => await _signIn(auth.signInWithGoogle);

  Future<User> signInWithFacebook() async =>
      await _signIn(auth.signInWithFacebook);
}
