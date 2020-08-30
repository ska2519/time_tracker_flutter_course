import 'package:intl/intl.dart';

abstract class FormatBase {
  String hours(double hours);
  String date(DateTime date);
  String dayOfWeek(DateTime date);
  String currency(double pay);
}

class Format implements FormatBase {
  //TODO: static method → instance methods
  // static method는 안변하기 때문에 앱 시작 후 시간이 안변함 instance로 변환 필요
  //TODO: Add top level Provider<Format> and use it
  // Format이 사용되는 EntryListItem, EntryPage에 Provider<Format> 부착

  @override
  String hours(double hours) {
    final hoursNotNegative = hours < 0.0 ? 0.0 : hours;
    final formatter = NumberFormat.decimalPattern();
    final formatted = formatter.format(hoursNotNegative);
    return '${formatted}h';
  }

  @override
  String date(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  @override
  String dayOfWeek(DateTime date) {
    return DateFormat.E().format(date);
  }

  @override
  String currency(double pay) {
    if (pay != 0.0) {
      final formatter = NumberFormat.simpleCurrency(decimalDigits: 0);
      return formatter.format(pay);
    }
    return '';
  }
}
