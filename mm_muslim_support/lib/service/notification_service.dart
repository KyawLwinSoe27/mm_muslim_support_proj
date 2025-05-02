import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mm_muslim_support/main.dart';
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    required String title,
    required String body,
    required int notificationId,
  }) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
      notificationId,
      title,
      body,
      _nextInstanceOfTime(hour, minute),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'daily_reminder_channel',
          'Daily Reminder',
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('azan'), // if you use custom sound
        ),
        iOS: DarwinNotificationDetails(
          sound: 'azan.mp3',
        ),
      ),
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }

  static tz.TZDateTime _nextInstanceOfTime(int hour, int minute) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate =
    tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }
}