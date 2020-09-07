import 'package:flutter/material.dart';
import 'package:mockito/mockito.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class MockAuth extends Mock implements AuthBase {}

class MockDatabase extends Mock implements DataBase {}

class MockNavigatorObserver extends Mock implements NavigatorObserver {}
