import 'package:flutter/services.dart';

class NativeLocationService {
  static const MethodChannel _channel =
  MethodChannel('native_location_channel');

  static Future<Map<String, double>?> getLocation() async {
    try {
      final result =
      await _channel.invokeMethod<Map>('getLocation');

      if (result == null) return null;

      return {
        'latitude': result['latitude'],
        'longitude': result['longitude'],
      };
    } catch (e) {
      return null;
    }
  }
}
