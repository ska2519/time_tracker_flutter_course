import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

//adding values to a model string that can be used as an input to a stream builder
class EmailSignInBloc {
  EmailSignInBloc({@required this.auth});
  final AuthBase auth;

  final _modelSubject = BehaviorSubject<EmailSignInModel>.seeded(EmailSignInModel());
  Stream<EmailSignInModel> get modelStream => _modelSubject.stream;

  // ⬆ 위와 동일 -
  /*final StreamController<EmailSignInModel> _modelController = StreamController<EmailSignInModel>();
  Stream<EmailSignInModel> get modelStream => _modelController.stream;*/

  //this will take all the default values 초기화 된 모델 변수로 스트림 컨트롤러와 모델 스트림을 설정
  //스트림의 현재 값을 나타내는 모델을 정의
  //EmailSignInModel _model = EmailSignInModel();
  //Subject에서 getter 사용 / instance variable change to getter variable
  EmailSignInModel get _model => _modelSubject.value;

  void dispose() {
    _modelSubject.close();
  }

  Future<void> submit() async {
    updateWith(
      submitted: true,
      isLoading: true,
    );
    try {
      if (_model.formType == EmailSignInFormType.signIn) {
        await auth.signInWithEmailAndPassword(_model.email, _model.password);
      } else {
        await auth.createWithEmailAndPassword(_model.email, _model.password);
      }
    } catch (e) {
      //sign In 실패시에만 isLoading : false 설정 필요 /로그인 시 homepage 로 이동 하기 때문에
      updateWith(isLoading: false);
      // 호출 코드까지 예외를 전달하는 방법
      rethrow;
    }
  }

  void toggleFormType() {
    final formType = _model.formType == EmailSignInFormType.signIn
        ? EmailSignInFormType.register
        : EmailSignInFormType.signIn;
    updateWith(
      email: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void emailUpdate(String email) => updateWith(email: email);
  void passwordUpdate(String password) => updateWith(password: password);

  void updateWith({
    String email,
    String password,
    EmailSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    //update Model
    _modelSubject.add(_model.copyWith(
      email: email,
      password: password,
      formType: formType,
      isLoading: isLoading,
      submitted: submitted,
    ));
  }
}
/* RxDart Subject 이용시 변경 사항
_model = _model.copyWith(
email: email,
password: password,
formType: formType,
isLoading: isLoading,
submitted: submitted,
);
//add updated model to _modelController
_modelController.add(_model);
}*/
