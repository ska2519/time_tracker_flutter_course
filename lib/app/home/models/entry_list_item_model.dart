import 'package:meta/meta.dart';
import 'package:time_tracker_flutter_course/services/format.dart';

class EntryListItemModel {
  EntryListItemModel({
    @required this.entry,
    @required this.job,
    @required this.format,
  });

  String entry;
  String job;
  Format format;
}
