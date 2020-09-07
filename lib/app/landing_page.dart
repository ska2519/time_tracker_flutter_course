import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/home_page.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class LandingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('build');
    final auth = Provider.of<AuthBase>(context, listen: false);
    return StreamBuilder<User>(
        //authStateChanges를 통해 보여주는 페이지 변경
        stream: auth.authStateChanges,
        builder: (context, snapshot) {
          print('$snapshot'); //ConnectionState.waiting ➡ ConnectionState.active
          if (snapshot.connectionState == ConnectionState.active) {
            User user = snapshot.data;
            if (user == null) {
              //SignInPage에  Provider 연결하기
              return SignInPage.create(context);
            }
            //JobsPage에 FirestoreDatabase 추적하는 Provider 장착
            //value로 추가 provider 장착
            return Provider<User>.value(
              value: user,
              child: Provider<DataBase>(
                create: (_) => FirestoreDatabase(uid: user.uid),
                child: HomePage(),
              ),
            );
          } else {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
        });
  }
}
