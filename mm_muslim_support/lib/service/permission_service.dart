import 'dart:io';
import 'package:flutter/services.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {

  static Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  Future<void> requestExactAlarmPermission() async {
    if (Platform.isAndroid) {
      const platform = MethodChannel('dexterx.dev/flutter_local_notifications_example');

      try {
        final bool isExactAlarmAllowed = await platform.invokeMethod('areExactAlarmsAllowed');

        if (!isExactAlarmAllowed) {
          var intent = const AndroidIntent(
            action: 'android.settings.REQUEST_SCHEDULE_EXACT_ALARM',
            flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
          );
          await intent.launch();
        }
      } catch (e) {
        print("Error requesting exact alarm permission: $e");
      }
    }
  }
}