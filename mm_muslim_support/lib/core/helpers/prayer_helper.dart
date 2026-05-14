import 'package:mm_muslim_support/core/enums/prayer.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';
import 'package:prayers_times/prayers_times.dart';

bool getPrayerAlarmValue(Prayer prayer) {
  switch (prayer) {
    case Prayer.sehri:
      return SharedPreferenceService.getSehriAlarm() ?? false;
    case Prayer.fajr:
      return SharedPreferenceService.getFajrAlarm() ?? false;
    case Prayer.dhur:
      return SharedPreferenceService.getDhuhrAlarm() ?? false;
    case Prayer.asr:
      return SharedPreferenceService.getAsrAlarm() ?? false;
    case Prayer.maghrib:
      return SharedPreferenceService.getMaghribAlarm() ?? false;
    case Prayer.isha:
      return SharedPreferenceService.getIshaAlarm() ?? false;
  }
}

void setPrayerAlarmValue(Prayer prayer, bool value) {
  switch (prayer) {
    case Prayer.sehri:
      SharedPreferenceService.setSehriAlarm(value);
    case Prayer.fajr:
      SharedPreferenceService.setFajrAlarm(value);
    case Prayer.dhur:
      SharedPreferenceService.setDhuhrAlarm(value);
    case Prayer.asr:
      SharedPreferenceService.setAsrAlarm(value);
    case Prayer.maghrib:
      SharedPreferenceService.setMaghribAlarm(value);
    case Prayer.isha:
      SharedPreferenceService.setIshaAlarm(value);
  }
}

DateTime? getPrayerTime(PrayerTimes prayerTimes, Prayer prayer) {
  switch (prayer) {
    case Prayer.sehri:
      return prayerTimes.sehri;
    case Prayer.fajr:
      return prayerTimes.fajrStartTime;
    case Prayer.dhur:
      return prayerTimes.dhuhrStartTime;
    case Prayer.asr:
      return prayerTimes.asrStartTime;
    case Prayer.maghrib:
      return prayerTimes.maghribStartTime;
    case Prayer.isha:
      return prayerTimes.ishaStartTime;
  }
}
