import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/model/prayer_calculation_method.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';

class GetPrayerCalculationMethodCubit extends Cubit<PrayerCalculationMethod> {
  GetPrayerCalculationMethodCubit() : super(prayerCalculationMethods.first);

  void choosePrayerCalculationMethod(PrayerCalculationMethod? method) {
    if(method != null) {
      SharedPreferenceService.setPrayerCalculationMethod(method.key.name);
      emit(method);
    } else {
      SharedPreferenceService.setPrayerCalculationMethod(state.key.name);
      emit(state);
    }
  }
}