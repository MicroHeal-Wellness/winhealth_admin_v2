import 'package:intl/intl.dart';

class DateTimeUtils {
  static String getUtcDateNow() {
    return DateTime.now().toUtc().toString();
  }

  static String apiFormattedCurrentTimestamp() {
    return (DateTime.now().millisecondsSinceEpoch / 1000).toString();
  }

  static String uiFormattedTime(String time) {
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    String dateTime = '${formatter.format(now)}T$time';
    DateTime parsed = DateTime.parse(dateTime).toLocal();
    return DateFormat.jm().format(parsed);
  }

  static String uiFormattedDate(String date) {
    DateTime parsed = DateTime.parse(date).toLocal();
    return DateFormat.yMMMd().format(parsed);
  }

  static String apiFormattedDate(String date) {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    DateTime parsed = DateTime.parse(date).toLocal();
    return formatter.format(parsed);
  }

  static String getTodayApiFormattedDate() {
    var today = DateTime.now();
    var dateFormat = DateFormat('yyyy-MM-dd');
    return dateFormat.format(today);
  }

  static String getIntervalTime(String time, int interval) {
    int minute = int.parse(time.substring(3, 5));
    if ((minute + int.parse(interval.toString())) > 60) {
      int hour = int.parse(time.substring(0, 2));
      return (hour + 1).toString() +
          (minute + int.parse(interval.toString()) - 60).toString();
    } else {
      return time.substring(0, 3) + (minute + interval).toString();
    }
  }
}
