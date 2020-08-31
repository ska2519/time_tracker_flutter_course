import 'package:meta/meta.dart';

class EntryListItemModel {
  EntryListItemModel({
    @required this.entry,
    @required this.job,
    this.dayOfWeek,
    this.startDate,
    this.startTime,
    this.endTime,
    this.durationFormatted,
  });

  String entry;
  String job;
  String dayOfWeek;
  String startDate;
  String startTime;
  String endTime;
  String durationFormatted;
}
