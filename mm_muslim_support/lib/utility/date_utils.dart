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
      case CustomDateFormat.yearMonth2:
        return DateFormat(format.value).format(dateTime);
    }
  }

  static DateTime? convertTo24HourDateTime(String time12h) {
    final trimmed = time12h.trim();
    final parts = trimmed.split(':');
    if (parts.length != 2) return null;

    final hour = int.tryParse(parts[0]);
    if (hour == null || hour < 1 || hour > 12) return null;

    final minutePart = parts[1].replaceAll(RegExp(r'[^0-9]'), '');
    final minute = int.tryParse(minutePart);
    if (minute == null || minute < 0 || minute > 59) return null;

    int adjustedHour = hour;
    if (trimmed.toLowerCase().contains('pm') && hour < 12) {
      adjustedHour = hour + 12;
    } else if (trimmed.toLowerCase().contains('am') && hour == 12) {
      adjustedHour = 0;
    }

    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, adjustedHour, minute);
  }
}
