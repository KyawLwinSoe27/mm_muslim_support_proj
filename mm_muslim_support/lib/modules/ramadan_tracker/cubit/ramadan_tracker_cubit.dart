// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mm_muslim_support/modules/ramadan_tracker/cubit/ramadan_tracker_state.dart';
// import 'package:mm_muslim_support/models/ramadan_day_model.dart';
// import 'package:mm_muslim_support/models/dua_model.dart';
// import 'package:mm_muslim_support/service/shared_preference_service.dart';
// import 'package:mm_muslim_support/core/enums/prayer.dart';
//
// class RamadanTrackerCubit extends Cubit<RamadanTrackerState> {
//   RamadanTrackerCubit() : super(RamadanTrackerInitial()) {
//     loadRamadanData();
//   }
//
//   Future<void> loadRamadanData() async {
//     // TODO: handle loading state if needed
//     // Get settings
//     final methodString = SharedPreferenceService.getPrayerCalculationMethod();
//     final madhabBool = SharedPreferenceService.getMadhab();
//     final locationString = SharedPreferenceService.getLocation();
//     final locationName = SharedPreferenceService.getLocationName() ?? 'Unknown';
//
//     // Parse location
//     final latLng = locationString?.split(',').map((e) => double.tryParse(e.trim())).toList();
//     final latitude = latLng != null && latLng.length == 2 ? latLng[0] ?? 0.0 : 0.0;
//     final longitude = latLng != null && latLng.length == 2 ? latLng[1] ?? 0.0 : 0.0;
//
//     // TODO: Map methodString to calculation method and madhab to plugin enums
//     // final calculationMethod = _mapCalculationMethod(methodString);
//     // final madhab = (madhabBool ?? false) ? Madhab.hanafi : Madhab.shafi;
//
//     // Generate Ramadan schedule (30 days)
//     final now = DateTime.now();
//     final ramadanStart = _findRamadanStart(now.year);
//     final schedule = <RamadanDayModel>[];
//     for (int i = 0; i < 30; i++) {
//       final date = ramadanStart.add(Duration(days: i));
//       // TODO: Use prayers_times plugin to get real prayer times for each day
//       final times = {
//         Prayer.fajr: DateTime(date.year, date.month, date.day, 4, 30),
//         Prayer.dhur: DateTime(date.year, date.month, date.day, 12, 15),
//         Prayer.asr: DateTime(date.year, date.month, date.day, 15, 45),
//         Prayer.maghrib: DateTime(date.year, date.month, date.day, 18, 20),
//         Prayer.isha: DateTime(date.year, date.month, date.day, 19, 40),
//       };
//       schedule.add(RamadanDayModel(
//         day: i + 1,
//         date: date,
//         prayerTimes: times,
//         isCompleted: false, // TODO: update with real completion logic
//         isToday: _isSameDay(date, now),
//       ));
//     }
//
//     // Mock duas
//     final duas = [
//       DuaModel(id: 1, arabic: 'اللهم إني لك صمت...', english: 'O Allah, I fasted for You...'),
//       DuaModel(id: 2, arabic: 'اللهم تقبل صيامنا...', english: 'O Allah, accept our fasting...'),
//     ];
//
//     emit(RamadanTrackerLoaded(
//       schedule: schedule,
//       currentDay: schedule.indexWhere((d) => d.isToday) + 1,
//       duas: duas,
//       locationName: locationName,
//     ));
//   }
//
//   // TODO: Map calculation method string to plugin enum/index
//   // int _mapCalculationMethod(String? method) {
//   //   return 0;
//   // }
//
//   DateTime _findRamadanStart(int year) {
//     // TODO: Use actual Ramadan start date logic or API
//     // For now, mock: 1st Ramadan 1447H = Feb 10, 2026
//     return DateTime(2026, 2, 10);
//   }
//
//   bool _isSameDay(DateTime a, DateTime b) {
//     return a.year == b.year && a.month == b.month && a.day == b.day;
//   }
// }
