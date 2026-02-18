import 'package:workmanager/workmanager.dart';
import 'package:mm_muslim_support/service/get_prayer_time_service.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';
import 'package:mm_muslim_support/service/local_notification_service.dart';
import 'package:mm_muslim_support/core/enums/prayer.dart';
import 'package:timezone/timezone.dart' as tz;

const String dailyPrayerTask = 'dailyPrayerRescheduleTask';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == dailyPrayerTask) {
      final notiService = LocalNotificationService();
      await notiService.initNotification();

      final prayerTimes =
      GetPrayerTimeService.getPrayerTimes();

      for (var prayer in Prayer.values) {
        final enabled = _getSavedAlarmValue(prayer);

        if (enabled) {
          DateTime? time = _getPrayerTime(prayerTimes, prayer);

          if (time != null &&
              time.isAfter(DateTime.now())) {
            await notiService.scheduleNotification(
              id: prayer.index,
              title: prayer.name.toUpperCase(),
              body:
              "It's time for ${prayer.name.toUpperCase()}",
              scheduledDate:
              tz.TZDateTime.from(time, tz.local),
            );
          }
        }
      }
    }

    return Future.value(true);
  });
}

bool _getSavedAlarmValue(Prayer prayer) {
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

DateTime? _getPrayerTime(prayerTimes, Prayer prayer) {
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
