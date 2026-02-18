import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/services.dart';
import 'package:mm_muslim_support/service/function_service.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';

class LocationService {
  static const MethodChannel _nativeChannel =
  MethodChannel('native_location_channel');

  /// ================================
  /// PUBLIC METHOD
  /// ================================

  static Future<Position?> getCurrentLocation() async {
    try {
      final position = await _getWithGeolocator();

      await _saveLocation(position.latitude, position.longitude);
      return position;
    } catch (_) {
      final nativeLocation = await _getWithNative();

      if (nativeLocation != null) {
        await _saveLocation(
          nativeLocation['latitude']!,
          nativeLocation['longitude']!,
        );

        return Position(
          latitude: nativeLocation['latitude']!,
          longitude: nativeLocation['longitude']!,
          timestamp: DateTime.now(),
          accuracy: 0,
          altitude: 0,
          altitudeAccuracy: 0,
          heading: 0,
          headingAccuracy: 0,
          speed: 0,
          speedAccuracy: 0,
        );
      }

      throw Exception('Unable to get location from any provider');
    }
  }

  /// ================================
  /// GEOLOCATOR (PRIMARY)
  /// ================================

  static Future<Position> _getWithGeolocator() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permission denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permission permanently denied');
    }

    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );
  }

  /// ================================
  /// NATIVE FALLBACK
  /// ================================

  static Future<Map<String, double>?> _getWithNative() async {
    try {
      final result =
      await _nativeChannel.invokeMethod<Map>('getLocation');

      if (result == null) return null;

      return {
        'latitude': result['latitude'],
        'longitude': result['longitude'],
      };
    } catch (_) {
      return null;
    }
  }

  /// ================================
  /// SAVE LOCATION + TIMEZONE
  /// ================================

  static Future<void> _saveLocation(
      double latitude,
      double longitude,
      ) async {
    String latLong = '${latitude}_$longitude';
    await SharedPreferenceService.setLocation(latLong);

    // Save timezone
    final timezone = await FlutterTimezone.getLocalTimezone();

    await SharedPreferenceService.setLocationName(
      FunctionService.locationName(timezone.identifier),
    );

    // Clear old placemark cache
    await getLocationAddress();
  }

  /// ================================
  /// GET HUMAN READABLE LOCATION
  /// ================================

  static Future<String?> getLocationAddress() async {
    String? cachedAddress =
    SharedPreferenceService.getPlaceMarksName();

    if (cachedAddress != null) {
      return cachedAddress;
    }

    final lat = getLatitude();
    final long = getLongitude();

    return await _getLocationFromPlaceMarks(lat, long);
  }

  static Future<String?> _getLocationFromPlaceMarks(
      double lat,
      double long,
      ) async {
    try {
      List<Placemark> placemarks =
      await placemarkFromCoordinates(lat, long);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        String? city = place.locality;
        String? state = place.administrativeArea;
        String? country = place.country;

        String address =
            '${city ?? ''}, ${state ?? ''}, ${country ?? ''}';

        await SharedPreferenceService.setPlaceMarksName(
          address,
        );

        return address;
      }
    } catch (_) {}

    return null;
  }

  /// ================================
  /// LAT LONG GETTERS
  /// ================================

  static double getLatitude() {
    final location =
    SharedPreferenceService.getLocation();

    if (location == null || !location.contains('_')) {
      return 0.0;
    }

    return double.tryParse(location.split('_')[0]) ??
        0.0;
  }

  static double getLongitude() {
    final location =
    SharedPreferenceService.getLocation();

    if (location == null || !location.contains('_')) {
      return 0.0;
    }

    return double.tryParse(location.split('_')[1]) ??
        0.0;
  }

  static String getLocationName() {
    return SharedPreferenceService.getLocationName() ??
        'Asia/Rangoon';
  }
}