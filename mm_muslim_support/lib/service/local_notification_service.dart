import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class LocalNotificationService {
  final notificationPlugin = FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  // INITIALIZE NOTIFICATION
  Future<void> initNotification() async {
    if (_isInitialized) return;

    // init time zone handling
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));

    // init Android
    const AndroidInitializationSettings initSettingAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    // init IOS

    const DarwinInitializationSettings initSettingIOS = DarwinInitializationSettings(requestAlertPermission: true, requestBadgePermission: true, requestSoundPermission: true);

    // init settings
    const InitializationSettings initSettings = InitializationSettings(android: initSettingAndroid, iOS: initSettingIOS);

    await notificationPlugin.initialize(initSettings);

    _isInitialized = true;
  }

  // Shown an immediate notification
  Future<void> showNotification({int id = 0, String? title, String? body}) async {
    await notificationPlugin.show(id, title, body, notificationDetail);
  }

  static AndroidNotificationDetails androidPlatformChannelSpecifics = const AndroidNotificationDetails(
    'your_channel_id',
    'your_channel_name',
    channelDescription: 'your_channel_description',
    importance: Importance.max,
    priority: Priority.max,
    playSound: true,
    visibility: NotificationVisibility.public,
    audioAttributesUsage: AudioAttributesUsage.alarm,
    sound: RawResourceAndroidNotificationSound('azan'),
  );

  static DarwinNotificationDetails iOSPlatformChannelSpecifics = const DarwinNotificationDetails(sound: 'azan.mp3');

  NotificationDetails notificationDetail = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

  // Schedule a notification
  Future<void> scheduleNotification({required int id, required String title, required String body, required int hour, required int minute}) async {

    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);

    await notificationPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduledDate,
      notificationDetail,

      // IOS specific: Use exact time specified
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,

      // Android specific: Use exact time specified
      androidScheduleMode: AndroidScheduleMode.alarmClock,

      // Make the notification repeat daily
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
    );
  }

  // Cancel All notification
  Future<void> cancelAllNotification() async {
    await notificationPlugin.cancelAll();
  }

  // Cancel Notification By Id
  Future<void> cancelNotificationById(int id) async{
    await notificationPlugin.cancel(id);
  }

}
