import 'package:intl/intl.dart';
import 'package:mm_muslim_support/core/enums/custom_date_format.dart';

class DateUtils {
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

}