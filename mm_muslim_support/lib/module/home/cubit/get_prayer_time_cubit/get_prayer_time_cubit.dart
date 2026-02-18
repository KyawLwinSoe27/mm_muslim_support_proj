import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/core/enums/custom_date_format.dart';
import 'package:mm_muslim_support/core/enums/prayer.dart';
import 'package:mm_muslim_support/model/custom_prayer_time.dart';
import 'package:mm_muslim_support/model/prayer_calculation_method.dart';
import 'package:mm_muslim_support/model/prayer_time_card.dart';
import 'package:mm_muslim_support/service/location_service.dart';
import 'package:mm_muslim_support/service/log_service.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';
import 'package:mm_muslim_support/utility/date_utils.dart';
import 'package:prayers_times/prayers_times.dart';
part 'get_prayer_time_state.dart';

class GetPrayerTimeCubit extends Cubit<GetPrayerTimeState> {
  GetPrayerTimeCubit() : super(GetPrayerTimeInitial());

  /* ------------------------------------------------ */
  /*                    PUBLIC API                    */
  /* ------------------------------------------------ */

  Future<void> getPrayerTime() async {
    emit(GetPrayerTimeLoading());

    try {
      final prayerTimes = _calculatePrayerTimes();
      final cards = _buildPrayerCards(prayerTimes);

      emit(GetPrayerTimeLoaded(cards));
    } catch (e) {
      _logError('Get Prayer Time', e);
      emit(GetPrayerTimeError(e.toString()));
    }
  }

  Future<void> getPrayerTimeByDate(DateTime date) async {
    emit(GetPrayerTimeByDateLoading());

    try {
      final prayerTimes = _calculatePrayerTimes(dateTime: date);
      final prayers = _buildDailyPrayerList(prayerTimes);

      emit(
        GetPrayerTimeByDateLoaded(
          prayerTimes: prayers,
          timeStamp: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    } catch (e) {
      _logError('Get Prayer Time By Date', e);
      emit(GetPrayerTimeByDateError(e.toString()));
    }
  }

  void toggleNotification(Prayer prayer) {
    final current = _getAlarmStatus(prayer);
    _setAlarmStatus(prayer, !current);
  }

  /* ------------------------------------------------ */
  /*                    BUILDERS                      */
  /* ------------------------------------------------ */

  List<PrayerTimeCard> _buildPrayerCards(PrayerTimes times) {
    final list = <PrayerTimeCard>[
      _staticCard('Sehri', times.sehri),
      _staticCard('Iftari', times.maghribStartTime),
    ];

    list.addAll(_currentAndNextCards(times));
    return list;
  }

  List<CustomPrayerTime> _buildDailyPrayerList(PrayerTimes times) {
    return Prayer.values.map((prayer) {
      final time = _getStartTime(times, prayer);
      return CustomPrayerTime(
        dateTime: times.date,
        prayerName: prayer,
        prayerTime:
        DateUtility.DateTimeToString(time!, CustomDateFormat.timeOnly),
        prayerDateTime: time,
        enableNotify: _getAlarmStatus(prayer),
      );
    }).toList();
  }

  /* ------------------------------------------------ */
  /*                PRAYER LOGIC                      */
  /* ------------------------------------------------ */

  PrayerTimes _calculatePrayerTimes({DateTime? dateTime}) {
    final coordinates = Coordinates(
      LocationService.getLatitude(),
      LocationService.getLongitude(),
    );

    final method = _getCalculationMethod();
    final locationName = LocationService.getLocationName();

    return PrayerTimes(
      coordinates: coordinates,
      calculationParameters: method,
      precision: true,
      locationName: locationName,
      dateTime: dateTime,
    );
  }

  PrayerCalculationParameters _getCalculationMethod() {
    final methodName =
        SharedPreferenceService.getPrayerCalculationMethod() ??
            'muslimWorldLeague';

    final madhab =
    (SharedPreferenceService.getMadhab() ?? true)
        ? PrayerMadhab.hanafi
        : PrayerMadhab.shafi;

    final methodEnum = PrayerCalculationMethodType.values.firstWhere(
          (e) => e.name == methodName,
      orElse: () => PrayerCalculationMethodType.muslimWorldLeague,
    );

    final params = getPrayerCalculationMethod(methodEnum);
    params.madhab = madhab;

    return params;
  }

  /* ------------------------------------------------ */
  /*                TIME HELPERS                      */
  /* ------------------------------------------------ */

  DateTime? _getStartTime(PrayerTimes times, Prayer prayer) {
    switch (prayer) {
      case Prayer.sehri:
        return times.sehri;
      case Prayer.fajr:
        return times.fajrStartTime;
      case Prayer.dhur:
        return times.dhuhrStartTime;
      case Prayer.asr:
        return times.asrStartTime;
      case Prayer.maghrib:
        return times.maghribStartTime;
      case Prayer.isha:
        return times.ishaStartTime;
    }
  }

  DateTime? _getEndTime(PrayerTimes times, String? prayerName) {
    switch (prayerName) {
      case 'fajr':
        return times.fajrEndTime;
      case 'dhuhr':
        return times.dhuhrEndTime;
      case 'asr':
        return times.asrEndTime;
      case 'maghrib':
        return times.maghribEndTime;
      case 'isha':
        return times.ishaEndTime;
      default:
        return null;
    }
  }

  String _format(DateTime? time) =>
      time != null ? DateFormat('hh:mm').format(time) : '--:--';

  /* ------------------------------------------------ */
  /*                CARD BUILDERS                     */
  /* ------------------------------------------------ */

  PrayerTimeCard _staticCard(String title, DateTime? time) {
    return PrayerTimeCard(
      title: title,
      time: _format(time),
      image: '',
      gradientColors: const [
        Color(0xFF00A86B),
        Color(0xFFDAF7DC),
      ],
    );
  }

  List<PrayerTimeCard> _currentAndNextCards(PrayerTimes times) {
    final current = times.currentPrayer();
    final next = times.nextPrayer();

    final list = <PrayerTimeCard>[];

    final end = _getEndTime(times, current);
    if (end != null) {
      list.add(
        PrayerTimeCard(
          title: 'Current',
          subtitle: current,
          time: 'End ${_format(end)}',
          image: '',
          gradientColors: const [
            Color(0xFF00A86B),
            Color(0xFFDAF7DC),
          ],
        ),
      );
    }

    final start = _getStartTime(times, Prayer.values.firstWhere(
          (e) => e.name == next,
      orElse: () => Prayer.fajr,
    ));

    if (start != null) {
      list.add(
        PrayerTimeCard(
          title: 'Coming',
          subtitle: next,
          time: 'Start ${_format(start)}',
          image: '',
          gradientColors: const [
            Color(0xFF6CA6CD),
            Color(0xFFB0E0E6),
          ],
        ),
      );
    }

    return list;
  }

  /* ------------------------------------------------ */
  /*                ALARM HANDLING                    */
  /* ------------------------------------------------ */

  bool _getAlarmStatus(Prayer prayer) {
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

  void _setAlarmStatus(Prayer prayer, bool value) {
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

  /* ------------------------------------------------ */
  /*                    LOGGER                        */
  /* ------------------------------------------------ */

  void _logError(String action, Object error) {
    LogService.logStorage.writeInfoLog(
      'GetPrayerTimeCubit',
      action,
      error.toString(),
    );
  }
}