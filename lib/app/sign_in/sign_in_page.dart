import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_button.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_manager.dart';
import 'package:time_tracker_flutter_course/app/sign_in/social_sign_in_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/firebaseauth_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key key, @required this.manager, @required this.isLoading})
      : super(key: key);
  //bloc을 생성자로 직접 전달
  final SignInManager manager;
  final bool isLoading;
  //static 정적 메서드로 만든 이유 / SignInBloc은 SignInPage와 함께 사용 가능
  //widget에 bloc 사용 시 정적 생성 메소드를 호출하여 프로젝트에서 사용하는 규칙
  //context와 child 사용하지 않기에 (_),(__) 표기 = place holder for the context argument
  static Widget create(BuildContext context) {
    final auth = Provider.of<AuthBase>(context);
    return ChangeNotifierProvider<ValueNotifier<bool>>(
      // init value 뒤에 적어줘야함?? 지금은 안하면 일단 에러
      create: (_) => ValueNotifier<bool>(false),
      child: Consumer<ValueNotifier<bool>>(
        //isLoading 값이 변경될 때 마다 Provider를 실행해 SignInManager 에 isLoading 값 전달
        builder: (_, isLoading, __) => Provider<SignInManager>(
          create: (_) => SignInManager(auth: auth, isLoading: isLoading),
          //Consumer 는 Provider 기반 동일한 모델 유형에 접근
          child: Consumer<SignInManager>(
            //builder는 ChangeNotifier 변경 될 때 호출 /SignInPage 도 rebuild
            builder: (_, manager, __) =>
                // .value로 bool 값 추출
                SignInPage(manager: manager, isLoading: isLoading.value),
          ),
/*      //widget이 위젯트리에서 지워질 때 bloc도 처분
          dispose: (context, bloc) => bloc.dispose(),*/
        ),
      ),
    );
  }

  //sign_in_page에서 오류 처리 하는 이유는 context가 필요
  void _showSignInError(BuildContext context, FirebaseAuthException exception) {
    FirebaseAuthExceptionAlertDialog(
      title: 'Sign in failed',
      exception: exception,
    ).show(context);
  }

  Future<void> _signInAnonymously(BuildContext context) async {
    try {
      await manager.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      _showSignInError(context, e);
    }
  }

  Future<void> _signInWithGoogle(BuildContext context) async {
    try {
      await manager.signInWithGoogle();
    } on FirebaseAuthException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  Future<void> _signInWithFacebook(BuildContext context) async {
    try {
      await manager.signInWithFacebook();
    } on FirebaseAuthException catch (e) {
      if (e.code != 'ERROR_ABORTED_BY_USER') {
        _showSignInError(context, e);
      }
    }
  }

  void _signInWithEmail(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        fullscreenDialog: true,
        builder: (context) => EmailSignInPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final isLoading = Provider.of<ValueNotifier<bool>>(context);
    return Scaffold(
      //appBar는 로딩과 관련 없어서 body만 스트림 빌더 적용
      appBar: AppBar(
        title: Text('Time Tracker'),
        elevation: 2.0,
      ),
      // body에 bool 타입 StreamBuilder 추가
      body: _buildContent(context),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContent(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 50.0,
            child: _buildHeader(),
          ),
          SizedBox(height: 30.0),
          SocialSignInButton(
            assetName: 'images/google-logo.png',
            text: 'Sign in with Google',
            textColor: Colors.black87,
            color: Colors.white,
            // 로딩 중 버튼 비 활성화
            onPressed: () => isLoading ? null : _signInWithGoogle(context),
          ),
          SizedBox(height: 8.0),
          SocialSignInButton(
            assetName: 'images/facebook-logo.png',
            text: 'Sign in with Facebook',
            textColor: Colors.white,
            color: Color(0xFF334D92),
            onPressed: () => isLoading ? null : _signInWithFacebook(context),
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Sign in with Email',
            textColor: Colors.white,
            color: Colors.teal[700],
            onPressed: () => isLoading ? null : _signInWithEmail(context),
          ),
          SizedBox(height: 8.0),
          Text(
            'or',
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),
          SignInButton(
            text: 'Go anonymous',
            textColor: Colors.black,
            color: Colors.lime[300],
            onPressed: () => isLoading ? null : _signInAnonymously(context),
          ),
        ],
      ),
    );
  }

  //헤더 분리하여 로딩중일시 서클 인디케이터 아닐 시 Sign in 표시
  Widget _buildHeader() {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return Text(
      'Sign in',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 32.0,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
