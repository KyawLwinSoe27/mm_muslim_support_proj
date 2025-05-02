import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mm_muslim_support/main.dart';

class LocalNotificationService {
  static Future<void> initializeNotifications() async {
    const AndroidInitializationSettings androidSettings =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      ),
    );

    await flutterLocalNotificationsPlugin.initialize(initSettings);
  }
}