import 'package:hijri/hijri_calendar.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';

class RamadanHelper {
  static HijriCalendar _getAdjustedHijriDate() {
    // 1️⃣ Current Gregorian date
    final DateTime todayDate = DateTime.now();

    // 2️⃣ Get saved offset
    final int offset =
        SharedPreferenceService.getHijriOffset() ?? 0;

    // 3️⃣ Apply offset BEFORE conversion
    final DateTime adjustedDate =
    todayDate.add(Duration(days: offset));

    // 4️⃣ Convert to Hijri
    return HijriCalendar.fromDate(adjustedDate);
  }

  static bool isRamadan() {
    final hijri = _getAdjustedHijriDate();
    return hijri.hMonth == 9;
  }

  static int getCompletedDays() {
    final hijri = _getAdjustedHijriDate();

    if (hijri.hMonth != 9) {
      return 0;
    }

    return hijri.hDay;
  }

  static int getTotalRamadanDays() {
    // Could be 29 or 30 — keep 30 for safe progress UI
    return 30;
  }

  static int getRemainingDays() {
    final completed = getCompletedDays();
    return getTotalRamadanDays() - completed;
  }

  static String getFormattedHijriDate() {
    final hijri = _getAdjustedHijriDate();
    return '${hijri.hDay} ${hijri.longMonthName} ${hijri.hYear} AH';
  }
}