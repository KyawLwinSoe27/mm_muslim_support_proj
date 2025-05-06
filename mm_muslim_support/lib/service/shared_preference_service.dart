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
  static const String _keyTheme = 'theme';
  static const String _keyPrayerCalcMethod = 'prayer_calc_method';
  static const String _keyAsrMethod = 'asr_method';
  static const String _keyNotification = 'notification_enabled';

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

  static Future<void> setLocationName(String locationName) async{
    await _prefs?.setString(_keyLocationName, locationName);
  }

  static Future<void> setPlaceMarksName(String placeMarksName) async{
    await _prefs?.setString(_keyPlaceMarksName, placeMarksName);
  }

  static String? getLocation() {
    return _prefs?.getString(_keyLocation);
  }

  static String? getLocationName() {
    return _prefs?.getString(_keyLocationName);
  }

  static String? getPlaceMarksName() {
    return _prefs?.getString(_keyPlaceMarksName);
  }

  // Theme
  Future<void> setTheme(String theme) async {
    await _prefs?.setString(_keyTheme, theme);
  }

  String? getTheme() {
    return _prefs?.getString(_keyTheme);
  }

  // Prayer Calculation Method
  Future<void> setPrayerCalculationMethod(int methodId) async {
    await _prefs?.setInt(_keyPrayerCalcMethod, methodId);
  }

  int? getPrayerCalculationMethod() {
    return _prefs?.getInt(_keyPrayerCalcMethod);
  }

  // Asr Method
  Future<void> setAsrMethod(int methodId) async {
    await _prefs?.setInt(_keyAsrMethod, methodId);
  }

  int? getAsrMethod() {
    return _prefs?.getInt(_keyAsrMethod);
  }

  // Notification
  Future<void> setNotificationEnabled(bool isEnabled) async {
    await _prefs?.setBool(_keyNotification, isEnabled);
  }

  bool getNotificationEnabled() {
    return _prefs?.getBool(_keyNotification) ?? true;
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