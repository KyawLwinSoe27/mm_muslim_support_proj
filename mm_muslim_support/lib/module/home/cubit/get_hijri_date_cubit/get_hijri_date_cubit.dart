import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hijri/hijri_calendar.dart';
import 'package:mm_muslim_support/model/today_date_model.dart';
import 'package:mm_muslim_support/service/log_service.dart';

part 'get_hijri_date_state.dart';

class GetHijriDateCubit extends Cubit<GetHijriDateState> {
  GetHijriDateCubit() : super(GetHijriDateInitial());

  void getTodayDate() {
    emit(GetHijriDateLoading());
    try {
      // Get the current date
      DateTime todayDate = DateTime.now();

      HijriCalendar h_date = HijriCalendar.fromDate(todayDate);

      // Create a TodayDateModel object with the current date
      TodayDateModel todayDateModel = TodayDateModel(
        gregorianDate: DateFormat('E, d MMMM').format(todayDate),
        hijriDate: h_date.toFormat('d, MMMM yyyy'),
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
