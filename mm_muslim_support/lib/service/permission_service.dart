import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  static Future<void> requestNotificationPermission() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }
}
