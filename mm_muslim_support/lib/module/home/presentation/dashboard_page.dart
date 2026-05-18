import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/module/home/cubit/get_prayer_time_cubit/get_prayer_time_cubit.dart';
import 'package:mm_muslim_support/module/home/cubit/prayer_tracker_cubit.dart';
import 'package:mm_muslim_support/module/home/widgets/greeting_section.dart';
import 'package:mm_muslim_support/module/home/widgets/prayer_section.dart';
import 'package:mm_muslim_support/module/home/widgets/prayer_time_grid_widget.dart';
import 'package:mm_muslim_support/module/home/widgets/quick_actions_grid.dart';
import 'package:mm_muslim_support/module/home/widgets/quick_stats_row.dart';
import 'package:mm_muslim_support/module/home/widgets/daily_content_section.dart';
import 'package:mm_muslim_support/module/home/widgets/section_header.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GetPrayerTimeCubit()..fetchPrayerTimes()),
        BlocProvider(create: (_) => PrayerTrackerCubit()),
      ],
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          children: [
            const GreetingSection(),
            const SizedBox(height: 8),
            const PrayerTimeGrid(),
            const SizedBox(height: 8),
            const PrayerSection(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SectionHeader(title: 'Quick Access', icon: Icons.explore_rounded),
            ),
            const SizedBox(height: 12),
            const QuickActionsGrid(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SectionHeader(title: "Today's Content", icon: Icons.auto_stories_rounded),
            ),
            const SizedBox(height: 12),
            const DailyContentSection(),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SectionHeader(title: 'Your Journey', icon: Icons.insights_rounded),
            ),
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: const QuickStatsRow(),
            ),
          ],
        ),
      ),
    );
  }
}
