import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/core/enums/custom_date_format.dart';
import 'package:mm_muslim_support/service/function_service.dart';
import 'package:mm_muslim_support/service/location_service.dart';
import 'package:mm_muslim_support/service/log_service.dart';
import 'package:mm_muslim_support/utility/date_utils.dart';
import 'package:prayers_times/prayers_times.dart';

part 'get_location_time_state.dart';

class GetLocationTimeCubit extends Cubit<GetLocationTimeState> {
  GetLocationTimeCubit() : super(GetLocationTimeInitial());

  void getLocationTime() async {
    emit(GetLocationTimeLoading());
    try {
      PrayerTimes prayerTimes = FunctionService.getPrayerTime();
      String? location = LocationService.getLocationName();

      emit(
        GetLocationTimeLoaded(
          location: location ?? '',
          date: DateUtility.DateTimeToString(
            DateTime.now(),
            CustomDateFormat.simpleDate,
          ),
          currentPrayer: prayerTimes.currentPrayer(),
        ),
      );
    } catch (e) {
      LogService.logStorage.writeInfoLog(
        'Get Location Time Cubit',
        'Get Location Time',
        e.toString(),
      );
      emit(const GetLocationTimeError('Failed to fetch location and time'));
    }
  }
}
