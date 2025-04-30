import 'dart:ui';

import 'package:easy_localization/easy_localization.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mm_muslim_support/model/prayer_time_card.dart';
import 'package:mm_muslim_support/utility/image_constants.dart';
import 'package:prayers_times/prayers_times.dart';

part 'get_prayer_time_state.dart';

class GetPrayerTimeCubit extends Cubit<GetPrayerTimeState> {
  GetPrayerTimeCubit() : super(GetPrayerTimeInitial());

  void getPrayerTime() async {
    emit(GetPrayerTimeLoading());
    try {
      List<PrayerTimeCard> prayerTimeList = [];

      Position? position = await _getCurrentLocation();
      if (position != null) {
        // Define the geographical coordinates for the location
        Coordinates coordinates = Coordinates(
          position.latitude,
          position.longitude,
        );

        // Specify the calculation parameters for prayer times
        PrayerCalculationParameters params = PrayerCalculationMethod.karachi();
        params.madhab = PrayerMadhab.hanafi;

        // Create a PrayerTimes instance for the specified location
        PrayerTimes prayerTimes = PrayerTimes(
          coordinates: coordinates,
          calculationParameters: params,
          precision: true,
          locationName: 'Asia/Yangon',
        );

        List<DateTime> times = [
          prayerTimes.fajrStartTime!,
          prayerTimes.fajrEndTime!,
          prayerTimes.dhuhrStartTime!,
          prayerTimes.dhuhrEndTime!,
          prayerTimes.asrStartTime!,
          prayerTimes.asrEndTime!,
          prayerTimes.maghribStartTime!,
          prayerTimes.maghribEndTime!,
          prayerTimes.ishaStartTime!,
          prayerTimes.ishaEndTime!,
        ];

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

        Map<String, dynamic> result = _getCurrentAndNextPrayer(times);
        String currentPrayer = result['now'];
        DateTime? nowEndTime = result['nowEndTime'];
        String nextPrayer = result['next'];
        DateTime nextTime = result['nextTime'];

        PrayerTimeCard nowTime = PrayerTimeCard(
          title: 'Now',
          subtitle: currentPrayer,
          time:
              nowEndTime != null
                  ? 'End in ${DateFormat('hh:mm').format(nowEndTime)} PM'
                  : 'Already Ended',
          image: '',
          gradientColors: [Color(0xFF6CA6CD), Color(0xFFB0E0E6)],
        );
        PrayerTimeCard comingPrayerTime = PrayerTimeCard(
          title: 'Coming...',
          subtitle: nextPrayer,
          time: 'Start ${DateFormat('hh:mm').format(nextTime)} PM',
          image: '',
          gradientColors: [Color(0xFF6CA6CD), Color(0xFFB0E0E6)],
        );

        prayerTimeList.add(nowTime);

        prayerTimeList.add(comingPrayerTime);

        emit(GetPrayerTimeLoaded(prayerTimeList));
      } else {
        emit(const GetPrayerTimeError('Unable to get location'));
      }
    } catch (e) {
      emit(GetPrayerTimeError(e.toString()));
    }
  }

  Future<Position?> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled
      return Future.error('Location services are disabled.');
    }

    // Check permission status
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are permanently denied
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // Get the current position
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  Map<String, dynamic> _getCurrentAndNextPrayer(List<DateTime> times) {
    final now = DateTime.now();

    for (int i = 0; i < times.length; i += 2) {
      DateTime start = times[i];
      DateTime end = times[i + 1];

      if (now.isAfter(start) && now.isBefore(end)) {
        String currentPrayer = _getPrayerNameByIndex(i);
        String nextPrayer =
            i + 2 < times.length ? _getPrayerNameByIndex(i + 2) : 'None';
        DateTime nextTime =
            i + 2 < times.length ? times[i + 2] : DateTime.now();

        return {
          'now': currentPrayer,
          'nowEndTime': end,
          'next': nextPrayer,
          'nextTime': nextTime,
        };
      }
    }

    // If none match, it's before Fajr or after Isha
    if (now.isBefore(times.first)) {
      return {
        'now': 'None',
        'nowEndTime': null,
        'next': 'Fajr',
        'nextTime': times.first,
      };
    } else {
      return {
        'now': 'Isha',
        'nowEndTime': times[9],
        'next': 'Fajr',
        'nextTime': times.first.add(Duration(days: 1)),
      };
    }
  }

  String _getPrayerNameByIndex(int index) {
    switch (index) {
      case 0:
      case 1:
        return 'Fajr';
      case 2:
      case 3:
        return 'Dhuhr';
      case 4:
      case 5:
        return 'Asr';
      case 6:
      case 7:
        return 'Maghrib';
      case 8:
      case 9:
        return 'Isha';
      default:
        return 'Unknown';
    }
  }
}
