import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mm_muslim_support/core/enums/prayer.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';
import 'package:mm_muslim_support/service/local_notification_service.dart';
import 'package:mm_muslim_support/service/get_prayer_time_service.dart';
import 'package:prayers_times/prayers_times.dart';
import 'package:timezone/timezone.dart' as tz;

part 'alarm_state.dart';

class AlarmCubit extends Cubit<AlarmState> {
  final LocalNotificationService _notiService = LocalNotificationService();

  AlarmCubit() : super(AlarmInitial()) {
    _initialize();
  }

  Future<void> _initialize() async {
    await _notiService.initNotification();
    loadAlarms();
    await rescheduleAllEnabledAlarms(); // 🔥 Important
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

    if (value) {
      await _schedulePrayer(prayer);
    } else {
      await _notiService.cancelNotificationById(prayer.index);
    }

    loadAlarms();
  }

  Future<void> _schedulePrayer(Prayer prayer) async {
    final prayerTimes = GetPrayerTimeService.getPrayerTimes();
    DateTime? time = _getPrayerTime(prayerTimes, prayer);

    if (time == null) return;

    // 🔥 If time already passed, schedule tomorrow
    if (time.isBefore(DateTime.now())) {
      final tomorrowTimes = GetPrayerTimeService.getPrayerTimes(
        dateTime: DateTime.now().add(const Duration(days: 1)),
      );

      time = _getPrayerTime(tomorrowTimes, prayer);
    }

    if (time == null) return;

    await _notiService.scheduleNotification(
      id: prayer.index,
      title: prayer.name.toUpperCase(),
      body: "It's time for ${prayer.name.toUpperCase()}",
      scheduledDate: tz.TZDateTime.from(time, tz.local),
    );
  }

  Future<void> rescheduleAllEnabledAlarms() async {
    for (var prayer in Prayer.values) {
      await _notiService.cancelNotificationById(prayer.index);

      final enabled = _getSavedAlarmValue(prayer);
      if (enabled) {
        await _schedulePrayer(prayer);
      }
    }
  }

  bool _getSavedAlarmValue(Prayer prayer) {
    switch (prayer) {
      case Prayer.sehri:
        return SharedPreferenceService.getSehriAlarm() ?? false;
      case Prayer.fajr:
        return SharedPreferenceService.getFajrAlarm() ?? false;
      case Prayer.dhur:
        return SharedPreferenceService.getDhuhrAlarm() ?? false;
      case Prayer.asr:
        return SharedPreferenceService.getAsrAlarm() ?? false;
      case Prayer.maghrib:
        return SharedPreferenceService.getMaghribAlarm() ?? false;
      case Prayer.isha:
        return SharedPreferenceService.getIshaAlarm() ?? false;
    }
  }

  DateTime? _getPrayerTime(PrayerTimes prayerTimes, Prayer prayer) {
    switch (prayer) {
      case Prayer.sehri:
        return prayerTimes.sehri;
      case Prayer.fajr:
        return prayerTimes.fajrStartTime;
      case Prayer.dhur:
        return prayerTimes.dhuhrStartTime;
      case Prayer.asr:
        return prayerTimes.asrStartTime;
      case Prayer.maghrib:
        return prayerTimes.maghribStartTime;
      case Prayer.isha:
        return prayerTimes.ishaStartTime;
    }
  }

  void _savePreference(Prayer prayer, bool value) {
    switch (prayer) {
      case Prayer.sehri:
        SharedPreferenceService.setSehriAlarm(value);
        break;
      case Prayer.fajr:
        SharedPreferenceService.setFajrAlarm(value);
        break;
      case Prayer.dhur:
        SharedPreferenceService.setDhuhrAlarm(value);
        break;
      case Prayer.asr:
        SharedPreferenceService.setAsrAlarm(value);
        break;
      case Prayer.maghrib:
        SharedPreferenceService.setMaghribAlarm(value);
        break;
      case Prayer.isha:
        SharedPreferenceService.setIshaAlarm(value);
        break;
    }
  }
}