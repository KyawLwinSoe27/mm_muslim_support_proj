import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:google_api_availability/google_api_availability.dart';
import 'package:mm_muslim_support/data/datasource/analytics_datasource.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AnalyticsService {
  static final AnalyticsService _instance = AnalyticsService._internal();
  factory AnalyticsService() => _instance;
  AnalyticsService._internal();

  final AnalyticsDataSource _dataSource = AnalyticsDataSource();
  FirebaseAnalytics? _analytics;
  bool _googleServicesAvailable = true;
  bool _initialized = false;
  String? _deviceId;
  String? _platform;
  String? _appVersion;
  late String _sessionId;

  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;
    _sessionId = '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(99999)}';

    if (Platform.isAndroid) {
      try {
        final availability = await GoogleApiAvailability.instance
            .checkGooglePlayServicesAvailability();
        _googleServicesAvailable =
            availability == GooglePlayServicesAvailability.success;
      } catch (_) {
        _googleServicesAvailable = false;
      }
    }

    if (_googleServicesAvailable) {
      _analytics = FirebaseAnalytics.instance;
    }

    await _collectDeviceInfo();
  }

  Future<void> _collectDeviceInfo() async {
    try {
      final devicePlugin = DeviceInfoPlugin();
      if (defaultTargetPlatform == TargetPlatform.android) {
        final android = await devicePlugin.androidInfo;
        _deviceId = android.id;
        _platform = 'android';
      } else if (defaultTargetPlatform == TargetPlatform.iOS) {
        final ios = await devicePlugin.iosInfo;
        _deviceId = ios.identifierForVendor;
        _platform = 'ios';
      }
      final packageInfo = await PackageInfo.fromPlatform();
      _appVersion = '${packageInfo.version}+${packageInfo.buildNumber}';
    } catch (_) {}
  }

  bool get _canUseFirebase => _googleServicesAvailable && _analytics != null;

  Future<void> logEvent({
    required String name,
    Map<String, Object>? parameters,
    String? screenName,
  }) async {
    if (!_canUseFirebase) return;
    try {
      await _analytics!.logEvent(name: name, parameters: parameters);
    } catch (_) {}

    try {
      await _dataSource.recordEvent({
        'eventName': name,
        'screenName': screenName,
        'parameters': parameters,
        'timestamp': DateTime.now().toUtc().toIso8601String(),
        'deviceId': _deviceId,
        'platform': _platform,
        'appVersion': _appVersion,
        'sessionId': _sessionId,
      });
    } catch (_) {}
  }

  Future<void> logScreenView({required String screenName}) async {
    await logEvent(
      name: 'screen_view',
      screenName: screenName,
    );
  }

  Future<void> logButtonTap({
    required String buttonName,
    String? screenName,
    Map<String, Object>? additionalParams,
  }) async {
    await logEvent(
      name: 'button_tap',
      screenName: screenName,
      parameters: {
        'buttonName': buttonName,
        if (additionalParams != null) ...additionalParams,
      },
    );
  }

  Future<void> logFeatureUsed({
    required String featureName,
    String? screenName,
    Map<String, Object>? additionalParams,
  }) async {
    await logEvent(
      name: 'feature_used',
      screenName: screenName,
      parameters: {
        'featureName': featureName,
        if (additionalParams != null) ...additionalParams,
      },
    );
  }

  Future<void> logSearch({
    required String searchTerm,
    String? screenName,
  }) async {
    await logEvent(
      name: 'search',
      screenName: screenName,
      parameters: {
        'searchTerm': searchTerm,
      },
    );
  }
}
