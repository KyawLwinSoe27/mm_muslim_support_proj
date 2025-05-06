import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  static final SharedPreferenceService _instance = SharedPreferenceService._internal();
  factory SharedPreferenceService() => _instance;
  SharedPreferenceService._internal();

  static SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  // Private Keys
  static const String _keyLanguage = 'language';
  static const String _keyLocation = 'latitude_longitude';
  static const String _keyLocationName = 'location_name';
  static const String _keyPlaceMarksName = 'place_marks_name';
  static const String _keyPrayerCalculationMethod = 'prayer_calculation_method';
  static const String _keyMadhab = 'madhab';

  // Language
  Future<void> setLanguage(String value) async {
    await _prefs?.setString(_keyLanguage, value);
  }

  String? getLanguage() {
    return _prefs?.getString(_keyLanguage);
  }

  // Location
  static Future<void> setLocation(String location) async {
    await _prefs?.setString(_keyLocation, location);
  }

  static String? getLocation() {
    return _prefs?.getString(_keyLocation);
  }


  static Future<void> setLocationName(String locationName) async{
    await _prefs?.setString(_keyLocationName, locationName);
  }

  static String? getLocationName() {
    return _prefs?.getString(_keyLocationName);
  }

  static Future<void> setPlaceMarksName(String placeMarksName) async{
    await _prefs?.setString(_keyPlaceMarksName, placeMarksName);
  }

  static String? getPlaceMarksName() {
    return _prefs?.getString(_keyPlaceMarksName);
  }

  static Future<void> setPrayerCalculationMethod(String method) async {
    await _prefs?.setString(_keyPrayerCalculationMethod, method);
  }

  static String? getPrayerCalculationMethod() {
    return _prefs?.getString(_keyPrayerCalculationMethod);
  }

  static Future<void> setMadhab(bool madhab) async {
    await _prefs?.setBool(_keyMadhab, madhab);
  }

  static bool? getMadhab() {
    return _prefs?.getBool(_keyMadhab);
  }

  // Remove
  static Future<void> removePlaceMarksName() async {
    await _prefs?.remove(_keyPlaceMarksName);
  }

  // Clear
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}