import 'package:firebase_core/firebase_core.dart';
import 'package:meta/meta.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_alert_dialog.dart';

class FirebaseExceptionAlertDialog extends PlatformAlertDialog {
  FirebaseExceptionAlertDialog({
    @required String title,
    @required FirebaseException exception,
  }) : super(
          title: title,
          content: _message(exception),
          defaultActionText: 'OK',
        );

  static String _message(FirebaseException exception) {
    print('익셉션 : $exception');
    return _errors[exception.code] ?? exception.message;
  }

  static Map<String, String> _errors = {
    /// - **email-already-in-use**:
    ///  - Thrown if there already exists an account with the given email address.
    /// - **invalid-email**:
    ///  - Thrown if the email address is not valid.
    /// - **operation-not-allowed**:
    ///  - Thrown if email/password accounts are not enabled. Enable
    ///    email/password accounts in the Firebase Console, under the Auth tab.
    /// - **weak-password**:
    ///  - Thrown if the password is not strong enough.
    'invalid-email': '이메일 주소가 유효하지 않습니다',

    ///  - Thrown if the email address is not valid.
    /// - **user-disabled**:
    ///  - Thrown if the user corresponding to the given email has been disabled.
    /// - **user-not-found**:
    ///  - Thrown if there is no user corresponding to the given email.
    'wrong-password': '비밀번호가 틀렸습니다',

    ///  - Thrown if the password is invalid for the given email, or the account
    ///    corresponding to the email does not have a password set.
  };
}
