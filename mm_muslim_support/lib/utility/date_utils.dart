import 'package:intl/intl.dart';
import 'package:mm_muslim_support/core/enums/custom_date_format.dart';

class DateUtility {
  /// Outputs "5:00 AM"
  DateFormat timeFormat = DateFormat.jm('en_US');

  static String DateTimeToString(DateTime dateTime, CustomDateFormat format) {
    switch (format) {
      case CustomDateFormat.fullDate:
        return DateFormat(format.value).format(dateTime);
      case CustomDateFormat.shortDate:
        return DateFormat(format.value).format(dateTime);
      case CustomDateFormat.timeOnly:
        return DateFormat(format.value).format(dateTime);
      case CustomDateFormat.dateTime:
        return DateFormat(format.value).format(dateTime);
      case CustomDateFormat.yearMonth:
        return DateFormat(format.value).format(dateTime);
      case CustomDateFormat.iso8601:
        return dateTime.toIso8601String();
      case CustomDateFormat.simpleDate:
        return DateFormat(format.value).format(dateTime);
      case CustomDateFormat.hijriDate:
        return DateFormat(format.value).format(dateTime);
    }
  }


  static DateTime convertTo24HourDateTime(String time12h) {
    int hour = 0;
    int minute = 0;
    time12h.trim();
    List<String> timeParts = time12h.split(':');

    if(time12h.toLowerCase().contains('pm')) {
      hour = int.parse(timeParts[0]) + 12;
    } else {
      hour = int.parse(timeParts[0]);
    }
    List<String> getMinutes = timeParts[1].split(' ');

    minute = int.parse(getMinutes[0]);

    final now = DateTime.now();

    // Create a new DateTime with today's date and parsed time
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

}