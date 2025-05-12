import 'package:mm_muslim_support/core/enums/prayer.dart';

class CustomPrayerTime {
  int id;
  final DateTime dateTime;
  final Prayer prayerName;
  final String prayerTime;
  final DateTime prayerDateTime;
  bool enableNotify;

  CustomPrayerTime({
    this.id = 0,
    required this.dateTime,
    required this.prayerName,
    required this.prayerTime,
    required this.prayerDateTime,
    this.enableNotify = false,
  });

  // toMap
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dateTime': dateTime.toIso8601String(),
      'name': prayerName,
      'time': prayerTime,
      'date': prayerDateTime.toIso8601String(),
      'alarm': enableNotify ? 1 : 0,
    };
  }

  // fromMap

  static CustomPrayerTime fromMap(Map<String, dynamic> map) {
    return CustomPrayerTime(
      id: map['id'],
      dateTime: DateTime.parse(map['dateTime']),
      prayerName: map['name'],
      prayerTime: map['time'],
      prayerDateTime: DateTime.parse(map['date']),
      enableNotify: map['alarm'] == 1,
    );
  }
}
