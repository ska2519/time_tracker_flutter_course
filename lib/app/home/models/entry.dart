import 'dart:ui';

import 'package:flutter/foundation.dart';

class Entry {
  Entry({
    @required this.id,
    @required this.jobId,
    @required this.start,
    @required this.end,
    this.comment,
  });

  String id;
  String jobId;
  DateTime start;
  DateTime end;
  String comment;

  double get durationInHours => end.difference(start).inMinutes.toDouble() / 60.0;

  //reading과 writing이 같은 type으로 일치(consistent)
  factory Entry.fromMap(Map<dynamic, dynamic> value, String id) {
    final int startMilliseconds = value['start'];
    final int endMilliseconds = value['end'];

    return Entry(
      id: id,
      jobId: value['jobId'],
      start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
      end: DateTime.fromMillisecondsSinceEpoch(endMilliseconds),
      comment: value['comment'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'jobId': jobId,
      'start': start.millisecondsSinceEpoch,
      'end': end.millisecondsSinceEpoch,
      'comment': comment,
    };
  }

  @override
  int get hashCode => hashValues(id, jobId, comment);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    //다른 개체가 현재 개체와 동일한 유형인지 확인
    if (runtimeType != other.runtimeType) return false;
    final Entry otherEntry = other;
    return id == otherEntry.id && jobId == otherEntry.jobId && comment == otherEntry.comment;
  }
}
