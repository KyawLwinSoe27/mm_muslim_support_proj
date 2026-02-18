import 'package:mm_muslim_support/core/enums/prayer.dart';

class RamadanDayModel {
  final int day;
  final DateTime date;
  final Map<Prayer, DateTime> prayerTimes;
  final bool isCompleted;
  final bool isToday;

  RamadanDayModel({
    required this.day,
    required this.date,
    required this.prayerTimes,
    this.isCompleted = false,
    this.isToday = false,
  });
}
