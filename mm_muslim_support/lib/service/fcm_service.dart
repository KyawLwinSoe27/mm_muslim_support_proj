import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:mm_muslim_support/core/helpers/firebase_availability.dart';
import 'package:mm_muslim_support/service/local_notification_service.dart';

@pragma('vm:entry-point')
Future<void> fcmBackgroundHandler(RemoteMessage message) async {
  // FCM automatically displays notifications in the background if the payload contains 'notification'.
  // We don't need to manually show a local notification here to avoid duplicates.
}

class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  String? _token;
  bool _isInitialized = false;

  String? get token => _token;

  Future<void> initialize() async {
    if (_isInitialized) return;
    if (!FirebaseAvailability.isAvailable) return;

    FirebaseMessaging.onBackgroundMessage(fcmBackgroundHandler);

    await _requestPermission();

    await _getToken();

    _fcm.onTokenRefresh.listen(_onTokenRefresh);

    FirebaseMessaging.onMessage.listen(_onMessage);

    FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);

    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      _handleMessage(initialMessage);
    }

    _isInitialized = true;
  }

  Future<String?> getToken() async {
    if (!FirebaseAvailability.isAvailable) return null;
    _token ??= await _fcm.getToken();
    return _token;
  }

  Future<void> _requestPermission() async {
    if (!FirebaseAvailability.isAvailable) return;
    await _fcm.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
  }

  Future<void> _getToken() async {
    if (!FirebaseAvailability.isAvailable) return;
    _token = await _fcm.getToken();
    if (_token != null) {
      debugPrint('FCM Token: $_token');
    }
  }

  Stream<String> get onTokenRefresh {
    if (!FirebaseAvailability.isAvailable) {
      return const Stream.empty();
    }
    return _fcm.onTokenRefresh;
  }

  void _onTokenRefresh(String token) {
    _token = token;
    debugPrint('FCM Token refreshed: $token');
  }

  void _onMessage(RemoteMessage message) {
    final notification = message.notification;
    if (notification != null) {
      LocalNotificationService().showNotification(
        title: notification.title,
        body: notification.body,
      );
    }
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    _handleMessage(message);
  }

  void _handleMessage(RemoteMessage message) {
    debugPrint('Notification tapped: ${message.messageId}');
  }
}
