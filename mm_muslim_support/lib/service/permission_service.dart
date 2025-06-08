import 'dart:io';

import 'package:google_api_availability/google_api_availability.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  static Future<bool> googleServiceAvailable() async {
    if(Platform.isIOS) {
      return true;
    }
    GooglePlayServicesAvailability availability =
        await GoogleApiAvailability.instance
            .checkGooglePlayServicesAvailability();
    return availability == GooglePlayServicesAvailability.success;
  }
}
