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

    // Schedule or cancel notification
    if (value) {
      final prayerTimes = GetPrayerTimeService.getPrayerTimes();
      DateTime? scheduledTime;

      if (prayer == Prayer.sehri) {
        scheduledTime = prayerTimes.sehri;
      } else {
        scheduledTime = _getPrayerTime(prayerTimes, prayer);
      }

      if (scheduledTime != null) {
        await _notiService.scheduleNotification(
          context: _context!,
          id: prayer.index,
          title: prayer.name.toUpperCase(),
          body: 'It\'s time for ${prayer.name.toUpperCase()}',
          scheduledDate: tz.TZDateTime.from(scheduledTime, tz.local),
        );
      }
    } else {
      await _notiService.cancelNotificationById(prayer.index);
    }

    loadAlarms();
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

  BuildContext? _context;

  void setContext(BuildContext context) {
    _context = context;
  }
}