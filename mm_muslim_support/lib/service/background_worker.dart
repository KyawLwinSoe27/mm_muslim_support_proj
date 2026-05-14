import 'package:workmanager/workmanager.dart';
import 'package:mm_muslim_support/core/enums/prayer.dart';
import 'package:mm_muslim_support/core/helpers/prayer_helper.dart';
import 'package:mm_muslim_support/service/get_prayer_time_service.dart';
import 'package:mm_muslim_support/service/local_notification_service.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';
import 'package:timezone/timezone.dart' as tz;

const String dailyPrayerTask = 'dailyPrayerRescheduleTask';

void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == dailyPrayerTask) {
      await SharedPreferenceService().init();
      final notiService = LocalNotificationService();
      await notiService.initNotification();

      final prayerTimes =
      GetPrayerTimeService.getPrayerTimes();

      for (var prayer in Prayer.values) {
        final enabled = getPrayerAlarmValue(prayer);

        if (enabled) {
          DateTime? time = getPrayerTime(prayerTimes, prayer);

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


