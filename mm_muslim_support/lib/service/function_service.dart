import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class FunctionService {
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
    return await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10,
        timeLimit: Duration(seconds: 5),
      ),
    );
  }

  static Future<String?> getLocation(double? latitude, double? longitude) async{

    if(latitude != null && longitude != null) {
      return await _getLocationFromPlacemarks(latitude,longitude);
    }

    Position? position = await FunctionService.getCurrentLocation();

    if (position != null) {
      double lat = position.latitude;
      double long = position.longitude;
      return await _getLocationFromPlacemarks(lat,long);

    }
    return null;
  }

  static Future<String?> _getLocationFromPlacemarks(double lat, double long) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(
      lat,
      long,
    );
    
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
    
      // You can access city, country, etc.
      String? city = place.locality;     // e.g., "Yangon"
      String? state = place.administrativeArea;
      String? country = place.country;
      return '$city, $state, $country';
    }
    return null;
  }
}