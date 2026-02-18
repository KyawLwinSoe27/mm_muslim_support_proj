import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:mm_muslim_support/model/today_date_model.dart';
import 'package:mm_muslim_support/service/log_service.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';

part 'get_hijri_date_state.dart';

class GetHijriDateCubit extends Cubit<GetHijriDateState> {
  GetHijriDateCubit() : super(GetHijriDateInitial());

  void getTodayDate() {
    emit(GetHijriDateLoading());
    try {
      // 1️⃣ Get current Gregorian date
      DateTime todayDate = DateTime.now();

      // 2️⃣ Get saved Hijri offset
      final int offset =
          SharedPreferenceService.getHijriOffset() ?? 0;

      // 3️⃣ Apply offset to Gregorian date BEFORE converting
      DateTime adjustedDate =
      todayDate.add(Duration(days: offset));

      // 4️⃣ Convert adjusted date to Hijri
      HijriCalendar hDate =
      HijriCalendar.fromDate(adjustedDate);

      // 5️⃣ Create model
      TodayDateModel todayDateModel = TodayDateModel(
        gregorianDate:
        DateFormat('E, d MMMM').format(todayDate),
        hijriDate:
        hDate.toFormat('d MMMM yyyy'),
      );

      emit(GetHijriDateLoaded(todayDateModel));
    } catch (e) {
      LogService.logStorage.writeInfoLog(
        'Get Hijri Date Cubit',
        'Get Today Date',
        e.toString(),
      );
      emit(const GetHijriDateError('Failed to fetch date'));
    }
  }
}
