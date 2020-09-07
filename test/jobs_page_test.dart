import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/jobs_page.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

import 'mocks.dart';

void main() {
  MockDatabase mockDatabase;
  StreamController<List<Job>> jobsStreamController;

  setUp(() {
    mockDatabase = MockDatabase();
    jobsStreamController = StreamController<List<Job>>();
  });

  tearDown(() {
    jobsStreamController.close();
  });

  Future<void> pumpJobsPage(WidgetTester tester) async {
    await tester.pumpWidget(
      Provider<DataBase>(
        create: (_) => mockDatabase,
        child: MaterialApp(
          home: JobsPage(),
        ),
      ),
    );
    //Widget state changes ➡ tester.pump();
    await tester.pump();
  }

  //iterable(반복) is a useful method of the stream
  void stubJobsStreamYields(Iterable<List<Job>> jobsStream) {
    jobsStreamController.addStream(
      Stream<List<Job>>.fromIterable(jobsStream),
    );
    when(mockDatabase.jobsStream()).thenAnswer((_) {
      return jobsStreamController.stream;
    });
  }

  testWidgets('stream waiting', (WidgetTester tester) async {
    stubJobsStreamYields([]);

    await pumpJobsPage(tester);

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
