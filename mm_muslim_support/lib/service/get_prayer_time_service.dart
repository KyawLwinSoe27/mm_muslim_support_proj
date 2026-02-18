import 'package:mm_muslim_support/model/prayer_calculation_method.dart';
import 'package:mm_muslim_support/service/location_service.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';
import 'package:prayers_times/prayers_times.dart';

class GetPrayerTimeService {
  const GetPrayerTimeService._();

  static PrayerTimes getPrayerTimes({DateTime? dateTime}) {
    final double latitude =
        LocationService.getLatitude();

    final double longitude =
        LocationService.getLongitude();

    final String locationName =
        LocationService.getLocationName();

    /// Get saved calculation method
    final String methodName =
        SharedPreferenceService.getPrayerCalculationMethod() ??
            'muslimWorldLeague';

    /// Convert string to enum safely
    final PrayerCalculationMethodType methodEnum =
    PrayerCalculationMethodType.values.firstWhere(
          (e) => e.name == methodName,
      orElse: () =>
      PrayerCalculationMethodType.muslimWorldLeague,
    );

    /// Get parameters
    final PrayerCalculationParameters params =
    getPrayerCalculationMethod(methodEnum);

    /// Apply Madhab
    final bool isHanafi =
        SharedPreferenceService.getMadhab() ?? true;

    params.madhab =
    isHanafi ? PrayerMadhab.hanafi : PrayerMadhab.shafi;

    /// Build coordinates
    final Coordinates coordinates =
    Coordinates(latitude, longitude);

    /// Return PrayerTimes
    return PrayerTimes(
      coordinates: coordinates,
      calculationParameters: params,
      locationName: locationName,
      dateTime: dateTime,
    );
  }
}
