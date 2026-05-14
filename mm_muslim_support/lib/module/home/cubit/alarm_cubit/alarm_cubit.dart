import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mm_muslim_support/core/enums/prayer.dart';
import 'package:mm_muslim_support/core/helpers/prayer_helper.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';
import 'package:mm_muslim_support/service/local_notification_service.dart';
import 'package:mm_muslim_support/service/get_prayer_time_service.dart';
import 'package:prayers_times/prayers_times.dart';
import 'package:timezone/timezone.dart' as tz;

part 'alarm_state.dart';

class AlarmCubit extends Cubit<AlarmState> {
  final LocalNotificationService _notiService = LocalNotificationService();
  static const int _batchDays = 30;

  AlarmCubit() : super(AlarmInitial()) {
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _notiService.initNotification();
    } catch (_) {}
    loadAlarms();
    await rescheduleAllEnabledAlarms();
  }

  void loadAlarms() {
    final alarms = {
      Prayer.sehri: SharedPreferenceService.getSehriAlarm() ?? false,
      Prayer.fajr: SharedPreferenceService.getFajrAlarm() ?? false,
      Prayer.dhur: SharedPreferenceService.getDhuhrAlarm() ?? false,
      Prayer.asr: SharedPreferenceService.getAsrAlarm() ?? false,
      Prayer.maghrib: SharedPreferenceService.getMaghribAlarm() ?? false,
      Prayer.isha: SharedPreferenceService.getIshaAlarm() ?? false,
    };

    emit(AlarmLoaded(alarms));
  }

  void toggleAlarm(Prayer prayer, bool value) async {
    _savePreference(prayer, value);

    try {
      if (value) {
        await _schedulePrayerBatch(prayer);
      } else {
        await _cancelPrayerBatch(prayer);
      }
    } catch (_) {}

    loadAlarms();
  }

  Future<void> _schedulePrayerBatch(Prayer prayer) async {
    try {
      // First cancel existing batch to avoid duplicates
      await _cancelPrayerBatch(prayer);
      
      final now = DateTime.now();
      
      for (int i = 0; i < _batchDays; i++) {
        final futureDate = now.add(Duration(days: i));
        final prayerTimes = GetPrayerTimeService.getPrayerTimes(dateTime: futureDate);
        DateTime? time = _getPrayerTime(prayerTimes, prayer);

        if (time == null) continue;

        if (time.isAfter(now)) {
          // Generate a unique ID for this specific prayer on this specific day offset
          final uniqueId = (prayer.index * 100) + i;

          await _notiService.scheduleNotification(
            id: uniqueId,
            title: prayer.name.toUpperCase(),
            body: "It's time for ${prayer.name.toUpperCase()}",
            scheduledDate: tz.TZDateTime.from(time, tz.local),
          );
        }
      }
    } catch (_) {}
  }
  
  Future<void> _cancelPrayerBatch(Prayer prayer) async {
    try {
      for (int i = 0; i < _batchDays; i++) {
        final uniqueId = (prayer.index * 100) + i;
        await _notiService.cancelNotificationById(uniqueId);
      }
    } catch (_) {}
  }

  Future<void> rescheduleAllEnabledAlarms() async {
    for (var prayer in Prayer.values) {
      await _cancelPrayerBatch(prayer);

      final enabled = _getSavedAlarmValue(prayer);
      if (enabled) {
        await _schedulePrayerBatch(prayer);
      }
    }
  }

  bool _getSavedAlarmValue(Prayer prayer) =>
      getPrayerAlarmValue(prayer);

  DateTime? _getPrayerTime(PrayerTimes prayerTimes, Prayer prayer) =>
      getPrayerTime(prayerTimes, prayer);

  void _savePreference(Prayer prayer, bool value) =>
      setPrayerAlarmValue(prayer, value);
}