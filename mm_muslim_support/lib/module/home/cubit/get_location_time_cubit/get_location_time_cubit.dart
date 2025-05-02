import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mm_muslim_support/core/enums/custom_date_format.dart';
import 'package:mm_muslim_support/service/function_service.dart';
import 'package:mm_muslim_support/utility/date_utils.dart';
import 'package:prayers_times/prayers_times.dart';

part 'get_location_time_state.dart';

class GetLocationTimeCubit extends Cubit<GetLocationTimeState> {
  GetLocationTimeCubit() : super(GetLocationTimeInitial());

  void getLocationTime() async{
    emit(GetLocationTimeLoading());
    try {
      DateTime dateTime = DateTime.now();
      Position? position = await FunctionService.getCurrentLocation();
      if (position != null) {
        // Define the geographical coordinates for the location
        Coordinates coordinates = Coordinates(
          position.latitude,
          position.longitude,
        );

        // Specify the calculation parameters for prayer times
        PrayerCalculationParameters params = PrayerCalculationMethod.karachi();
        params.madhab = PrayerMadhab.hanafi;

        // Create a PrayerTimes instance for the specified location
        PrayerTimes prayerTimes = PrayerTimes(
          coordinates: coordinates,
          calculationParameters: params,
          precision: true,
          locationName: 'Asia/Rangoon',
          dateTime: dateTime
        );

        String location = await FunctionService.getLocation(position.latitude, position.longitude) ?? '';

        emit(GetLocationTimeLoaded(location: location, date: DateUtils.DateTimeToString(dateTime, CustomDateFormat.simpleDate), currentPrayer: prayerTimes.currentPrayer()));
      }
    } catch (e) {
      emit(const GetLocationTimeError('Failed to fetch location and time'));
    }
  }
}
