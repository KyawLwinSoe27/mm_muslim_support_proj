import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/service/location_service.dart';
import 'package:mm_muslim_support/service/log_service.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';

part 'get_location_state.dart';

class GetLocationCubit extends Cubit<GetLocationState> {
  GetLocationCubit() : super(GetLocationInitial());

  void getCurrentLocation() async {
    emit(GetLocationLoading());
    try {
      await SharedPreferenceService.removePlaceMarksName();
      await LocationService.getCurrentLocation(); // get lat and long
      await LocationService.getLocation(); // get location name

      String location = SharedPreferenceService.getPlaceMarksName() ?? '';
      emit(GetLocationLoaded(location: 'Your updated location is $location'));
    } catch (e) {
      LogService.logStorage.writeInfoLog('Get Location Cubit', 'Get Current Location', e.toString());

      emit(const GetLocationError('Failed to get location'));
    }
  }
}
