import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mm_muslim_support/service/function_service.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';

class LocationService {
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return Future.error('Location services are disabled.');
    }

    // Check permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // Get the current position
    Position currentLocation = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
      ),
    );

    // Save the location to shared preferences
    String locationLanLong =
        '${currentLocation.latitude}_${currentLocation.longitude}';
    await SharedPreferenceService.setLocation(locationLanLong);

    // get timezone name
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    await SharedPreferenceService.setLocationName(
      FunctionService.locationName(timeZoneName),
    );

    return currentLocation;
  }

  static Future<String?> getLocation() async {
    String? address = SharedPreferenceService.getPlaceMarksName();
    if (address != null) {
      return address;
    } else {
      double lat = double.parse(
        SharedPreferenceService.getLocation()?.split('_')[0] ?? '0.0',
      );
      double long = double.parse(
        SharedPreferenceService.getLocation()?.split('_')[1] ?? '0.0',
      );

      return await _getLocationFromPlaceMarks(lat, long);
    }
  }

  static Future<String?> _getLocationFromPlaceMarks(
    double lat,
    double long,
  ) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(lat, long);

    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;

      // You can access city, country, etc.
      String? city = place.locality; // e.g., "Yangon"
      String? state = place.administrativeArea;
      String? country = place.country;
      String address = '$city, $state, $country';
      await SharedPreferenceService.setPlaceMarksName(address);
      return address;
    }
    return null;
  }

  static double getLatitude() {
    return double.parse(
      SharedPreferenceService.getLocation()?.split('_')[0] ?? '0.0',
    );
  }

  static double getLongitude() {
    return double.parse(
      SharedPreferenceService.getLocation()?.split('_')[1] ?? '0.0',
    );
  }

  static String getLocationName() {
    return SharedPreferenceService.getLocationName() ?? 'Asia/Rangoon';
  }
}
