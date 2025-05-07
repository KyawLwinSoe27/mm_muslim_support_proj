import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/core/enums/custom_date_format.dart';
import 'package:mm_muslim_support/model/custom_prayer_time.dart';
import 'package:mm_muslim_support/model/prayer_calculation_method.dart';
import 'package:mm_muslim_support/model/prayer_time_card.dart';
import 'package:mm_muslim_support/service/location_service.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';
import 'package:mm_muslim_support/utility/date_utils.dart';
import 'package:mm_muslim_support/utility/image_constants.dart';
import 'package:prayers_times/prayers_times.dart';

part 'get_prayer_time_state.dart';

class GetPrayerTimeCubit extends Cubit<GetPrayerTimeState> {
  GetPrayerTimeCubit() : super(GetPrayerTimeInitial());

  void getPrayerTime() async {
    emit(GetPrayerTimeLoading());
    try {
      final PrayerTimes prayerTimes = _getPrayerTime();

      final prayerTimeList = <PrayerTimeCard>[_createStaticCard('Sehri', prayerTimes.sehri, ImageConstants.sehri), _createStaticCard('Iftari', prayerTimes.maghribStartTime, ImageConstants.iftar)];

      final currentPrayer = prayerTimes.currentPrayer();
      final nextPrayer = prayerTimes.nextPrayer();

      final currentEndTime = _getPrayerEndTime(prayerTimes, currentPrayer);
      if (currentEndTime != null) {
        prayerTimeList.add(
          _createDynamicCard(title: 'Current', subtitle: currentPrayer, timeLabel: 'End in ${_formatTime(currentEndTime)}', colors: [const Color(0xFF00A86B), const Color(0xFFDAF7DC)]),
        );
      }

      final nextStartTime = _getPrayerStartTime(prayerTimes, nextPrayer);
      if (nextStartTime != null) {
        prayerTimeList.add(_createDynamicCard(title: 'Coming...', subtitle: nextPrayer, timeLabel: 'Start ${_formatTime(nextStartTime)}', colors: [const Color(0xFF6CA6CD), const Color(0xFFB0E0E6)]));
      }

      emit(GetPrayerTimeLoaded(prayerTimeList));
    } catch (e) {
      emit(GetPrayerTimeError(e.toString()));
    }
  }

  void getPrayerTimeByDate(DateTime date) async {
    emit(GetPrayerTimeByDateLoading());
    try {
      final prayerTime = _getPrayerTime(dateTime: date);

      final dateFormat = CustomDateFormat.timeOnly;

      final prayerTimes = [
        _buildCustomPrayer('Fajr', prayerTime.fajrStartTime!, prayerTime.date, dateFormat),
        _buildCustomPrayer('Dhuhr', prayerTime.dhuhrStartTime!, prayerTime.date, dateFormat),
        _buildCustomPrayer('Asr', prayerTime.asrStartTime!, prayerTime.date, dateFormat),
        _buildCustomPrayer('Maghrib', prayerTime.maghribStartTime!, prayerTime.date, dateFormat),
        _buildCustomPrayer('Isha', prayerTime.ishaStartTime!, prayerTime.date, dateFormat),
      ];

      emit(GetPrayerTimeByDateLoaded(prayerTimes: prayerTimes, timeStamp: DateTime.now().millisecond));
    } catch (e) {
      emit(GetPrayerTimeByDateError(e.toString()));
    }
  }

  void toggleNotificationEnable(int index, List<CustomPrayerTime> prayerTimes, bool value) {
    prayerTimes[index].enableNotify = value;
    emit(GetPrayerTimeByDateLoaded(prayerTimes: prayerTimes, timeStamp: DateTime.now().millisecond));
  }

  /// Utilities

  PrayerTimeCard _createStaticCard(String title, DateTime? time, String imagePath) {
    return PrayerTimeCard(title: title, time: _formatTime(time), image: imagePath, gradientColors: [const Color(0xFF00A86B), const Color(0xFFDAF7DC)]);
  }

  PrayerTimeCard _createDynamicCard({required String title, required String subtitle, required String timeLabel, required List<Color> colors}) {
    return PrayerTimeCard(title: title, subtitle: subtitle, time: timeLabel, image: '', gradientColors: colors);
  }

  String _formatTime(DateTime? dateTime) {
    return dateTime != null ? DateFormat('hh:mm').format(dateTime) : '--:--';
  }

  DateTime? _getPrayerStartTime(PrayerTimes times, String? prayer) {
    switch (prayer) {
      case 'fajr':
        return times.fajrStartTime;
      case 'dhuhr':
        return times.dhuhrStartTime;
      case 'asr':
        return times.asrStartTime;
      case 'maghrib':
        return times.maghribStartTime;
      case 'isha':
        return times.ishaStartTime;
      default:
        return null;
    }
  }

  DateTime? _getPrayerEndTime(PrayerTimes times, String? prayer) {
    switch (prayer) {
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

  CustomPrayerTime _buildCustomPrayer(String name, DateTime time, DateTime date, CustomDateFormat format) {
    return CustomPrayerTime(dateTime: date, prayerName: name, prayerTime: DateUtility.DateTimeToString(time, format), hour: time.hour, minute: time.minute, enableNotify: false);
  }

  PrayerTimes _getPrayerTime({DateTime? dateTime}) {

    final latitude = LocationService.getLatitude();
    final longitude = LocationService.getLongitude();
    final locationName = LocationService.getLocationName();
    final methodName = SharedPreferenceService.getPrayerCalculationMethod() ?? 'muslimWorldLeague';
    final prayerMadhab = SharedPreferenceService.getMadhab() ?? true;

    final coordinates = Coordinates(latitude, longitude);

    final PrayerCalculationMethodType methodEnum = PrayerCalculationMethodType.values.firstWhere(
          (e) => e.name == methodName,
      orElse: () => PrayerCalculationMethodType.muslimWorldLeague,
    );

    PrayerCalculationParameters params = getPrayerCalculationMethod(methodEnum);
    params.madhab = prayerMadhab ? PrayerMadhab.hanafi : PrayerMadhab.shafi;


    return PrayerTimes(coordinates: coordinates, calculationParameters: params, precision: true, locationName: locationName, dateTime: dateTime);
  }
}
