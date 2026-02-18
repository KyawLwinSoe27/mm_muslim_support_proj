import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:mm_muslim_support/core/enums/custom_date_format.dart';
import 'package:mm_muslim_support/module/home/cubit/get_prayer_time_cubit/get_prayer_time_cubit.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';
import 'package:mm_muslim_support/utility/date_utils.dart';

class ChangeDateState {
  final String gregorianDate;
  final String hijriDate;

  ChangeDateState({required this.gregorianDate, required this.hijriDate});
}

class ChangeDateCubit extends Cubit<ChangeDateState> {
  final GetPrayerTimeCubit getPrayerTimeCubit;

  ChangeDateCubit({required this.getPrayerTimeCubit})
      : super(ChangeDateState(gregorianDate: '', hijriDate: '')) {
    _emitWithOffset(date);
  }

  DateTime date = DateTime.now();

  /// 🔥 Central method — always use this
  void _emitWithOffset(DateTime baseDate) {
    // 1️⃣ Get saved Hijri offset
    final int offset =
        SharedPreferenceService.getHijriOffset() ?? 0;

    // 2️⃣ Apply offset BEFORE converting
    final DateTime adjustedDate =
    baseDate.add(Duration(days: offset));

    // 3️⃣ Convert adjusted date to Hijri
    final HijriCalendar hDate =
    HijriCalendar.fromDate(adjustedDate);

    emit(
      ChangeDateState(
        gregorianDate: DateUtility.DateTimeToString(
          baseDate,
          CustomDateFormat.simpleDate,
        ),
        hijriDate:
        hDate.toFormat(CustomDateFormat.hijriDate.value),
      ),
    );

    // Prayer times should use ORIGINAL Gregorian date
    getPrayerTimeCubit.getPrayerTimeByDate(baseDate);
  }

  void increment() {
    date = date.add(const Duration(days: 1));
    _emitWithOffset(date);
  }

  void decrement() {
    date = date.subtract(const Duration(days: 1));
    _emitWithOffset(date);
  }

  void setDate(DateTime newDate) {
    date = newDate;
    _emitWithOffset(newDate);
  }
}
