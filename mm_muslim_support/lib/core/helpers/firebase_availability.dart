import 'dart:io';

import 'package:google_api_availability/google_api_availability.dart';

class FirebaseAvailability {
  static bool _isAvailable = true;
  static bool _checked = false;

  static bool get isAvailable => _isAvailable;
  static bool get hasChecked => _checked;

  static Future<bool> checkAvailability() async {
    if (_checked) return _isAvailable;
    _checked = true;
    if (Platform.isIOS) {
      _isAvailable = true;
      return true;
    }
    try {
      final availability = await GoogleApiAvailability.instance
          .checkGooglePlayServicesAvailability();
      _isAvailable = availability == GooglePlayServicesAvailability.success;
    } catch (_) {
      _isAvailable = false;
    }
    return _isAvailable;
  }
}
