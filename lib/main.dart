import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/landing_page.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Create the initilization Future outside of `build`:
  Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return CircularProgressIndicator();
        }
        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          return Provider<AuthBase>(
            create: (context) => Auth(),
            child: MaterialApp(
              title: 'Time Tracker',
              theme: ThemeData(
                primarySwatch: Colors.indigo,
              ),
              home: LandingPage(),
            ),
          );
        }
        // Otherwise, show something whilst waiting for initialization to complete
        return CircularProgressIndicator();
      },
    );
  }
}
