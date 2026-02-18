import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/model/prayer_calculation_method.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';

class GetPrayerCalculationMethodCubit extends Cubit<PrayerCalculationMethod> {
  GetPrayerCalculationMethodCubit() : super(_loadInitialMethod());

  static PrayerCalculationMethod _loadInitialMethod() {
    final savedKey = SharedPreferenceService.getPrayerCalculationMethod();
    if (savedKey != null) {
      return prayerCalculationMethods.firstWhere(
            (method) => method.key.name == savedKey,
        orElse: () => prayerCalculationMethods.first,
      );
    }
    return prayerCalculationMethods.first;
  }

  void choosePrayerCalculationMethod(PrayerCalculationMethod? method) {
    if (method != null) {
      SharedPreferenceService.setPrayerCalculationMethod(method.key.name);
      emit(method);
    }
  }
}

