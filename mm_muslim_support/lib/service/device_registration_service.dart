import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:intl/intl.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:mm_muslim_support/model/device_info.dart';
import 'package:mm_muslim_support/repository/user_repository.dart';
import 'package:mm_muslim_support/service/fcm_service.dart';

class DeviceRegistrationService {
  final UserRepository _repository = UserRepository();
  String? _deviceId;

  Future<void> registerDevice({String? fcmToken}) async {
    if (!await _isGoogleServiceAvailable()) return;

    final info = await _collectDeviceInfo(fcmToken: fcmToken);
    await _repository.registerOrUpdateDevice(info);
    _deviceId = info.deviceId;

    _listenForTokenRefresh();
  }

  void _listenForTokenRefresh() {
    FcmService().onTokenRefresh.listen((token) {
      if (_deviceId != null) {
        _repository.updateFcmToken(_deviceId!, token);
      }
    });
  }

  Future<bool> _isGoogleServiceAvailable() async {
    if (Platform.isIOS) return true;
    try {
      final availability = await GoogleApiAvailability.instance
          .checkGooglePlayServicesAvailability();
      return availability == GooglePlayServicesAvailability.success;
    } catch (_) {
      return false;
    }
  }

  Future<DeviceInfo> _collectDeviceInfo({String? fcmToken}) async {
    final devicePlugin = DeviceInfoPlugin();
    String deviceId = '';
    String? deviceModel;
    String? deviceName;
    String? osVersion;

    try {
      if (defaultTargetPlatform == TargetPlatform.android) {
        final android = await devicePlugin.androidInfo;
        deviceId = android.id;
        deviceModel = android.model;
        deviceName = android.device;
        osVersion = android.version.release;
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final ios = await devicePlugin.iosInfo;
        deviceId = ios.identifierForVendor ?? '';
        deviceModel = ios.model;
        deviceName = ios.name;
        osVersion = ios.systemVersion;
      }
    } catch (_) {}

    final packageInfo = await PackageInfo.fromPlatform();
    final timezone = await FlutterTimezone.getLocalTimezone();
    final timezoneName = timezone.identifier;

    return DeviceInfo(
      deviceId: deviceId,
      deviceModel: deviceModel,
      deviceName: deviceName,
      platform: defaultTargetPlatform.name,
      osVersion: osVersion,
      appVersion: '${packageInfo.version}+${packageInfo.buildNumber}',
      fcmToken: fcmToken,
      language: Intl.getCurrentLocale(),
      timezone: timezoneName,
    );
  }
}
