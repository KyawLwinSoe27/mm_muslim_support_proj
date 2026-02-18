// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mm_muslim_support/modules/ramadan_tracker/cubit/ramadan_tracker_cubit.dart';
// import 'package:mm_muslim_support/modules/ramadan_tracker/cubit/ramadan_tracker_state.dart';
// import 'package:mm_muslim_support/modules/ramadan_tracker/widgets/header_section.dart';
// import 'package:mm_muslim_support/modules/ramadan_tracker/widgets/progress_section.dart';
// import 'package:mm_muslim_support/modules/ramadan_tracker/widgets/time_cards_row.dart';
// import 'package:mm_muslim_support/modules/ramadan_tracker/widgets/monthly_schedule_list.dart';
// import 'package:mm_muslim_support/modules/ramadan_tracker/widgets/daily_dua_carousel.dart';
// import 'package:mm_muslim_support/modules/ramadan_tracker/widgets/bottom_nav_placeholder.dart';
//
// /// Ramadan Tracker Page
// /// Route: /ramadan_tracker
// class RamadanTrackerPage extends StatelessWidget {
//   static const String routeName = '/ramadan_tracker';
//   const RamadanTrackerPage({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => RamadanTrackerCubit(),
//       child: BlocBuilder<RamadanTrackerCubit, RamadanTrackerState>(
//         builder: (context, state) {
//           if (state is RamadanTrackerLoaded) {
//             final today = state.schedule[state.currentDay - 1];
//             final suhoorTime = _formatTime(today.prayerTimes.values.first);
//             final iftarTime = _formatTime(today.prayerTimes.values.elementAt(3));
//             final nextPrayer = today.prayerTimes.entries.firstWhere((e) => e.value.isAfter(DateTime.now()), orElse: () => today.prayerTimes.entries.first);
//             return Directionality(
//               textDirection: TextDirection.rtl,
//               child: Scaffold(
//                 backgroundColor: Theme.of(context).colorScheme.surface,
//                 body: SafeArea(
//                   child: SingleChildScrollView(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         HeaderSection(
//                           title: 'Ramadan Tracker',
//                           location: state.locationName,
//                           dayIndicator: 'Day ${state.currentDay}',
//                           onBack: () {}, // TODO: Implement navigation
//                           onShare: () {}, // TODO: Implement share
//                         ),
//                         const SizedBox(height: 8),
//                         ProgressSection(
//                           progress: state.currentDay / state.schedule.length,
//                           daysLeft: state.schedule.length - state.currentDay,
//                           totalDays: state.schedule.length,
//                         ),
//                         const SizedBox(height: 16),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           child: TimeCardsRow(
//                             suhoorTime: suhoorTime,
//                             nextPrayerName: nextPrayer.key.name,
//                             nextPrayerTime: _formatTime(nextPrayer.value),
//                             iftarTime: iftarTime,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         Padding(
//                           padding: const EdgeInsets.symmetric(horizontal: 8),
//                           child: MonthlyScheduleList(
//                             schedule: state.schedule,
//                             currentDay: state.currentDay,
//                           ),
//                         ),
//                         const SizedBox(height: 16),
//                         DailyDuaCarousel(duas: state.duas),
//                         const SizedBox(height: 24),
//                         const BottomNavPlaceholder(),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }
//           return const Center(child: CircularProgressIndicator());
//         },
//       ),
//     );
//   }
//
//   String _formatTime(DateTime time) {
//     return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
//   }
// }
