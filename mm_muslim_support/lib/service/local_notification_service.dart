import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mm_muslim_support/service/function_service.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

class NotiPayLoad {
  final int id;
  final String name;

  const NotiPayLoad({
    required this.id,
    required this.name
});
}

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
    tz.setLocalLocation(tz.getLocation(FunctionService.locationName(timeZoneName)));

    // init Android
    const AndroidInitializationSettings initSettingAndroid = AndroidInitializationSettings('@drawable/ic_launcher');

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
    icon: '@drawable/ic_launcher',
  );

  static DarwinNotificationDetails iOSPlatformChannelSpecifics = const DarwinNotificationDetails(sound: 'azan.mp3');

  NotificationDetails notificationDetail = NotificationDetails(android: androidPlatformChannelSpecifics, iOS: iOSPlatformChannelSpecifics);

  // Schedule a notification
  // Future<void> scheduleNotification({required int id, required String title, required String body, required tz.TZDateTime scheduledDate}) async {
  //   await notificationPlugin.zonedSchedule(
  //     id,
  //     title,
  //     body,
  //     scheduledDate,
  //     notificationDetail,
  //
  //     // IOS specific: Use exact time specified
  //     uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
  //
  //     // Android specific: Use exact time specified
  //     androidScheduleMode: AndroidScheduleMode.alarmClock,
  //
  //     // Make the notification repeat daily
  //     matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
  //   );
  // }

  Future<void> scheduleNotification({
    required BuildContext context,
    required int id,
    required String title,
    required String body,
    required tz.TZDateTime scheduledDate,
  }) async {
    try {
      await notificationPlugin.zonedSchedule(
        id,
        title,
        body,
        scheduledDate,
        notificationDetail,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Notification scheduled for ${scheduledDate.toLocal()}'),
          backgroundColor: Colors.green,
        ),
      );
      FirebaseCrashlytics.instance.log('Scheduled notification with ID $id at $scheduledDate');

    } catch (e, stack) {
      print('Error scheduling notification: $e');
      print('Stack trace: $stack');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to schedule notification: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(minutes: 5),
        ),
      );

      FirebaseCrashlytics.instance.log('Scheduled notification with ID $id at $scheduledDate. The error is $e');
    }
  }


  // Cancel All notification
  Future<void> cancelAllNotification() async {
    await notificationPlugin.cancelAll();
  }

  // Cancel Notification By Id
  Future<void> cancelNotificationById(int id) async{
    await notificationPlugin.cancel(id);
  }
  Future<List<NotiPayLoad>> retrievePendingNotificationList() async {
    final List<PendingNotificationRequest> pendingNotificationList =
    await notificationPlugin.pendingNotificationRequests();

    return pendingNotificationList.map((notification) {
      return NotiPayLoad(
        id: notification.id,
        name: notification.title ?? 'No Title',
      );
    }).toList();
  }

}
