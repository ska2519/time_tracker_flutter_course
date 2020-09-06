import 'package:flutter_test/flutter_test.dart';
import 'package:time_tracker_flutter_course/app/home/models/entry.dart';
import 'package:time_tracker_flutter_course/app/home/models/job.dart';

void main() {
  group('fromMap', () {
    test('null data', () {
      final entry = Entry.fromMap(null, 'abc');
      expect(entry, null);
    });

    test('entry with all properties', () {
      final entry = Entry.fromMap({
        'id': 'abc',
        'jobId': 'jobId',
        'start': DateTime.fromMillisecondsSinceEpoch(12),
        'end': DateTime(12),
        'comment': '머할래',
      }, 'abc');
      expect(entry.id, 'abc');
      expect(entry.jobId, 'jobId');
      expect(entry.comment, '머할래');

      // equality operator - bool operator ==(Object other)
      expect(
          entry,
          Entry(
            id: 'abc',
            jobId: 'jobId',
            start: DateTime.fromMillisecondsSinceEpoch(11),
            end: DateTime.fromMillisecondsSinceEpoch(12),
            comment: '머할래',
          ));
    });

    test('missing name', () {
      final job = Job.fromMap({
        'ratePerHour': 10,
      }, 'abc');
      expect(job, null);
    });
  });

  group('toMap', () {
    test('valid name, ratePerHour', () {
      final job = Job(name: 'Blogging', ratePerHour: 10, id: 'abc');
      expect(job.toMap(), {
        'name': 'Blogging',
        'ratePerHour': 10,
      });
    });
  });
}
