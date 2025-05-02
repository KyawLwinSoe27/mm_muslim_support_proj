import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:mm_muslim_support/core/enums/custom_date_format.dart';
import 'package:mm_muslim_support/module/home/cubit/get_prayer_time_cubit/get_prayer_time_cubit.dart';
import 'package:mm_muslim_support/utility/date_utils.dart';

class ChangeDateState {
  final String gregorianDate;
  final String hijriDate;

  ChangeDateState({required this.gregorianDate, required this.hijriDate});
}

class ChangeDateCubit extends Cubit<ChangeDateState> {
  GetPrayerTimeCubit getPrayerTimeCubit;
  ChangeDateCubit({required this.getPrayerTimeCubit}) : super(ChangeDateState(gregorianDate: '', hijriDate: '')) {
    HijriCalendar h_date = HijriCalendar.fromDate(date);
    emit(ChangeDateState(gregorianDate: DateUtils.DateTimeToString(date, CustomDateFormat.simpleDate), hijriDate: h_date.toFormat(CustomDateFormat.hijriDate.value)));
    getPrayerTimeCubit.getPrayerTimeByDate(date);
  }

  DateTime date = DateTime.now();

  void increment() async {
    DateTime newDate = date.add(const Duration(days: 1));
    date = newDate;
    HijriCalendar h_date = HijriCalendar.fromDate(newDate);

    emit(ChangeDateState(gregorianDate: DateUtils.DateTimeToString(newDate, CustomDateFormat.simpleDate), hijriDate: h_date.toFormat(CustomDateFormat.hijriDate.value)));
    getPrayerTimeCubit.getPrayerTimeByDate(newDate);
  }

  void decrement() async {
    DateTime newDate = date.subtract(const Duration(days: 1));
    date = newDate;
    HijriCalendar h_date = HijriCalendar.fromDate(newDate);
    emit(ChangeDateState(gregorianDate: DateUtils.DateTimeToString(newDate, CustomDateFormat.simpleDate), hijriDate: h_date.toFormat(CustomDateFormat.hijriDate.value)));
    getPrayerTimeCubit.getPrayerTimeByDate(newDate);
  }

  void setDate(DateTime date) async {
    this.date = date;
    HijriCalendar h_date = HijriCalendar.fromDate(date);
    emit(ChangeDateState(gregorianDate: DateUtils.DateTimeToString(date, CustomDateFormat.simpleDate), hijriDate: h_date.toFormat(CustomDateFormat.hijriDate.value)));
    getPrayerTimeCubit.getPrayerTimeByDate(date);
  }
}
