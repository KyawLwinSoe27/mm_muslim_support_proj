import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/model/daily_quran_dua_model.dart';
import 'package:mm_muslim_support/module/home/cubit/daily_quran_dua_cubit.dart';
import 'package:mm_muslim_support/module/home/widgets/custom_card_widget.dart';
import 'package:mm_muslim_support/module/home/widgets/prayer_time_grid_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        children: [
          const PrayerTimeGrid(),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _SectionHeader(title: 'Daily Dua', icon: Icons.menu_book_rounded),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlocProvider(
              create: (context) => DailyQuranDuaCubit(dailyDuaList),
              child: BlocBuilder<DailyQuranDuaCubit, DailyQuranDuaModel>(
                builder: (context, state) => DailyQuranDuaWidget(
                  title: 'Daily Dua',
                  dailyQuranDuaModel: state,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _SectionHeader(title: 'Daily Quran Verse', icon: Icons.auto_stories_rounded),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: BlocProvider(
              create: (context) => DailyQuranDuaCubit(dailyQuranList),
              child: BlocBuilder<DailyQuranDuaCubit, DailyQuranDuaModel>(
                builder: (context, state) => DailyQuranDuaWidget(
                  title: 'Daily Quran Verse',
                  dailyQuranDuaModel: state,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 20, color: theme.colorScheme.primary),
        const SizedBox(width: 8),
        Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}
