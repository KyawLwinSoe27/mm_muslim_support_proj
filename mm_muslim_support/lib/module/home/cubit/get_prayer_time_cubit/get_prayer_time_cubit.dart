import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mm_muslim_support/core/enums/custom_date_format.dart';
import 'package:mm_muslim_support/model/custom_prayer_time.dart';
import 'package:mm_muslim_support/model/prayer_time_card.dart';
import 'package:mm_muslim_support/service/function_service.dart';
import 'package:mm_muslim_support/service/location_service.dart';
import 'package:mm_muslim_support/utility/date_utils.dart';
import 'package:mm_muslim_support/utility/image_constants.dart';
import 'package:prayers_times/prayers_times.dart';

part 'get_prayer_time_state.dart';

class GetPrayerTimeCubit extends Cubit<GetPrayerTimeState> {
  GetPrayerTimeCubit() : super(GetPrayerTimeInitial());

  void getPrayerTime() async {
    emit(GetPrayerTimeLoading());
    try {
      List<PrayerTimeCard> prayerTimeList = [];

      double latitude = LocationService.getLatitude();
      double longitude = LocationService.getLongitude();
      String locationName = LocationService.getLocationName();

      // Define the geographical coordinates for the location
      Coordinates coordinates = Coordinates(latitude, longitude);

      // Specify the calculation parameters for prayer times
      PrayerCalculationParameters params = PrayerCalculationMethod.karachi();
      params.madhab = PrayerMadhab.hanafi;

      // Create a PrayerTimes instance for the specified location
      PrayerTimes prayerTimes = PrayerTimes(coordinates: coordinates, calculationParameters: params, precision: true, locationName: locationName);

      PrayerTimeCard sehriTime = PrayerTimeCard(
        title: 'Sehri',
        time: DateFormat('hh:mm').format(prayerTimes.sehri!),
        image: ImageConstants.sehri,
        gradientColors: [const Color(0xFF00A86B), const Color(0xFFDAF7DC)],
      );

      prayerTimeList.add(sehriTime);

      PrayerTimeCard iftarTime = PrayerTimeCard(
        title: 'Iftari',
        time: DateFormat('hh:mm').format(prayerTimes.maghribStartTime!),
        image: ImageConstants.iftar,
        gradientColors: [const Color(0xFF00A86B), const Color(0xFFDAF7DC)],
      );

      prayerTimeList.add(iftarTime);

      if(prayerTimes.currentPrayer() == 'Fajr') {
        PrayerTimeCard currentPrayerTime = PrayerTimeCard(
          title: 'Current',
          subtitle: prayerTimes.currentPrayer(),
          time: 'End in ${DateFormat('hh:mm').format(prayerTimes.fajrEndTime!)} AM',
          image: '',
          gradientColors: [const Color(0xFF00A86B), const Color(0xFFDAF7DC)],
        );
        prayerTimeList.add(currentPrayerTime);
      } else if (prayerTimes.currentPrayer() == 'Dhuhr') {
        PrayerTimeCard currentPrayerTime = PrayerTimeCard(
          title: 'Current',
          subtitle: prayerTimes.currentPrayer(),
          time: 'End in ${DateFormat('hh:mm').format(prayerTimes.dhuhrEndTime!)} PM',
          image: '',
          gradientColors: [const Color(0xFF00A86B), const Color(0xFFDAF7DC)],
        );
        prayerTimeList.add(currentPrayerTime);
      } else if (prayerTimes.currentPrayer() == 'Asr') {
        PrayerTimeCard currentPrayerTime = PrayerTimeCard(
          title: 'Current',
          subtitle: prayerTimes.currentPrayer(),
          time: 'End in ${DateFormat('hh:mm').format(prayerTimes.asrEndTime!)} PM',
          image: '',
          gradientColors: [const Color(0xFF00A86B), const Color(0xFFDAF7DC)],
        );
        prayerTimeList.add(currentPrayerTime);
      } else if (prayerTimes.currentPrayer() == 'Maghrib') {
        PrayerTimeCard currentPrayerTime = PrayerTimeCard(
          title: 'Now',
          subtitle: prayerTimes.currentPrayer(),
          time: 'End in ${DateFormat('hh:mm').format(prayerTimes.maghribEndTime!)} PM',
          image: '',
          gradientColors: [const Color(0xFF00A86B), const Color(0xFFDAF7DC)],
        );
        prayerTimeList.add(currentPrayerTime);
      } else if (prayerTimes.currentPrayer() == 'Isha') {
        PrayerTimeCard currentPrayerTime = PrayerTimeCard(
          title: 'Now',
          subtitle: prayerTimes.currentPrayer(),
          time: 'End in ${DateFormat('hh:mm').format(prayerTimes.ishaEndTime!)} PM',
          image: '',
          gradientColors: [const Color(0xFF00A86B), const Color(0xFFDAF7DC)],
        );
        prayerTimeList.add(currentPrayerTime);
      }

      if(prayerTimes.nextPrayer() == 'Fajr') {
        PrayerTimeCard comingPrayerTime = PrayerTimeCard(
          title: 'Coming...',
          subtitle: prayerTimes.nextPrayer(),
          time: 'Start ${DateFormat('hh:mm').format(prayerTimes.fajrStartTime!)} AM',
          image: '',
          gradientColors: [const Color(0xFF6CA6CD), const Color(0xFFB0E0E6)],
        );
        prayerTimeList.add(comingPrayerTime);
      } else if (prayerTimes.nextPrayer() == 'Dhuhr') {
        PrayerTimeCard comingPrayerTime = PrayerTimeCard(
          title: 'Coming...',
          subtitle: prayerTimes.nextPrayer(),
          time: 'Start ${DateFormat('hh:mm').format(prayerTimes.dhuhrStartTime!)} PM',
          image: '',
          gradientColors: [const Color(0xFF6CA6CD), const Color(0xFFB0E0E6)],
        );
        prayerTimeList.add(comingPrayerTime);
      } else if (prayerTimes.nextPrayer() == 'Asr') {
        PrayerTimeCard comingPrayerTime = PrayerTimeCard(
          title: 'Coming...',
          subtitle: prayerTimes.nextPrayer(),
          time: 'Start ${DateFormat('hh:mm').format(prayerTimes.asrStartTime!)} PM',
          image: '',
          gradientColors: [const Color(0xFF6CA6CD), const Color(0xFFB0E0E6)],
        );
        prayerTimeList.add(comingPrayerTime);
      } else if (prayerTimes.nextPrayer() == 'Maghrib') {
        PrayerTimeCard comingPrayerTime = PrayerTimeCard(
          title: 'Coming...',
          subtitle: prayerTimes.nextPrayer(),
          time: 'Start ${DateFormat('hh:mm').format(prayerTimes.maghribStartTime!)} PM',
          image: '',
          gradientColors: [const Color(0xFF6CA6CD), const Color(0xFFB0E0E6)],
        );
        prayerTimeList.add(comingPrayerTime);
      } else if (prayerTimes.nextPrayer() == 'Isha') {
        PrayerTimeCard comingPrayerTime = PrayerTimeCard(
          title: 'Coming...',
          subtitle: prayerTimes.nextPrayer(),
          time: 'Start ${DateFormat('hh:mm').format(prayerTimes.ishaStartTime!)} PM',
          image: '',
          gradientColors: [const Color(0xFF6CA6CD), const Color(0xFFB0E0E6)],
        );
        prayerTimeList.add(comingPrayerTime);
      }
      emit(GetPrayerTimeLoaded(prayerTimeList));
    } catch (e) {
      emit(GetPrayerTimeError(e.toString()));
    }
  }

  void getPrayerTimeByDate(DateTime date) async {
    emit(GetPrayerTimeByDateLoading());
    try {
      double latitude = LocationService.getLatitude();
      double longitude = LocationService.getLongitude();
      String locationName = LocationService.getLocationName();
      // Define the geographical coordinates for the location
      Coordinates coordinates = Coordinates(latitude, longitude);

      // Specify the calculation parameters for prayer times
      PrayerCalculationParameters params = PrayerCalculationMethod.karachi();
      params.madhab = PrayerMadhab.hanafi;

      // Create a PrayerTimes instance for the specified location
      PrayerTimes prayerTime = PrayerTimes(
        coordinates: coordinates,
        calculationParameters: params,
        precision: true,
        locationName: 'Asia/Rangoon',
        dateTime: date, // Specify the desired date
      );

      CustomDateFormat dateFormat = CustomDateFormat.timeOnly;

      List<CustomPrayerTime> prayerTimes = [
        CustomPrayerTime(
          dateTime: prayerTime.date,
          prayerName: 'Fajr',
          prayerTime: DateUtils.DateTimeToString(prayerTime.fajrStartTime!, dateFormat),
          hour: prayerTime.fajrStartTime!.hour,
          minute: prayerTime.fajrStartTime!.minute,
          enableNotify: false,
        ),
        CustomPrayerTime(
          dateTime: prayerTime.date,
          prayerName: 'Dhuhr',
          prayerTime: DateUtils.DateTimeToString(prayerTime.dhuhrStartTime!, dateFormat),
          hour: prayerTime.dhuhrStartTime!.hour,
          minute: prayerTime.dhuhrStartTime!.minute,
          enableNotify: false,
        ),
        CustomPrayerTime(
          dateTime: prayerTime.date,
          prayerName: 'Asr',
          prayerTime: DateUtils.DateTimeToString(prayerTime.asrStartTime!, dateFormat),
          hour: prayerTime.asrStartTime!.hour,
          minute: prayerTime.asrStartTime!.minute,
          enableNotify: false,
        ),
        CustomPrayerTime(
          dateTime: prayerTime.date,
          prayerName: 'Maghrib',
          prayerTime: DateUtils.DateTimeToString(prayerTime.maghribStartTime!, dateFormat),
          hour: prayerTime.maghribStartTime!.hour,
          minute: prayerTime.maghribStartTime!.minute,
          enableNotify: false,
        ),
        CustomPrayerTime(
          dateTime: prayerTime.date,
          prayerName: 'Isha',
          prayerTime: DateUtils.DateTimeToString(prayerTime.ishaStartTime!, dateFormat),
          hour: prayerTime.ishaStartTime!.hour,
          minute: prayerTime.ishaStartTime!.minute,
          enableNotify: false,
        ),
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
}
