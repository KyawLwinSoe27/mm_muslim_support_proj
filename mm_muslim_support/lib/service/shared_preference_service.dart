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

  static const String _keyIsFajrAlarm = 'is_fajr_alarm';
  static const String _keyIsDhuhrAlarm = 'is_dhuhr_alarm';
  static const String _keyIsAsrAlarm = 'is_asr_alarm';
  static const String _keyIsMaghribAlarm = 'is_maghrib_alarm';
  static const String _keyIsIshaAlarm = 'is_isha_alarm';



  // Setters
  Future<void> setLanguage(String value) async {
    await _prefs?.setString(_keyLanguage, value);
  }

  static Future<void> setLocation(String location) async {
    await _prefs?.setString(_keyLocation, location);
  }

  static Future<void> setLocationName(String locationName) async{
    await _prefs?.setString(_keyLocationName, locationName);
  }

  static Future<void> setPlaceMarksName(String placeMarksName) async{
    await _prefs?.setString(_keyPlaceMarksName, placeMarksName);
  }

  static Future<void> setPrayerCalculationMethod(String method) async {
    await _prefs?.setString(_keyPrayerCalculationMethod, method);
  }

  static Future<void> setMadhab(bool madhab) async {
    await _prefs?.setBool(_keyMadhab, madhab);
  }

  static Future<void> setFajrAlarm(bool isFajrAlarm) async {
    await _prefs?.setBool(_keyIsFajrAlarm, isFajrAlarm);
  }

  static Future<void> setDhuhrAlarm(bool isDhuhrAlarm) async {
    await _prefs?.setBool(_keyIsDhuhrAlarm, isDhuhrAlarm);
  }

  static Future<void> setAsrAlarm(bool isAsrAlarm) async {
    await _prefs?.setBool(_keyIsAsrAlarm, isAsrAlarm);
  }

  static Future<void> setMaghribAlarm(bool isMaghribAlarm) async {
    await _prefs?.setBool(_keyIsMaghribAlarm, isMaghribAlarm);
  }

  static Future<void> setIshaAlarm(bool isIshaAlarm) async {
    await _prefs?.setBool(_keyIsIshaAlarm, isIshaAlarm);
  }


  String? getLanguage() {
    return _prefs?.getString(_keyLanguage);
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

  static String? getPrayerCalculationMethod() {
    return _prefs?.getString(_keyPrayerCalculationMethod);
  }

  static bool? getMadhab() {
    return _prefs?.getBool(_keyMadhab);
  }
  
  static bool? getFajrAlarm() {
    return _prefs?.getBool(_keyIsFajrAlarm);
  }

  static bool? getDhuhrAlarm() {
    return _prefs?.getBool(_keyIsDhuhrAlarm);
  }

  static bool? getAsrAlarm() {
    return _prefs?.getBool(_keyIsAsrAlarm);
  }

  static bool? getMaghribAlarm() {
    return _prefs?.getBool(_keyIsMaghribAlarm);
  }
  
  static bool? getIshaAlarm() {
    return _prefs?.getBool(_keyIsIshaAlarm);
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