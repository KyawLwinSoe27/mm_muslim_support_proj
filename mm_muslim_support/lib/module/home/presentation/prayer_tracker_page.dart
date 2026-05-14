import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/module/home/cubit/prayer_tracker_cubit.dart';

class PrayerTrackerPage extends StatelessWidget {
  const PrayerTrackerPage({super.key});
  static const String routeName = '/prayer_tracker';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Prayer Tracker'),
        centerTitle: true,
      ),
      body: BlocProvider(
        create: (_) => PrayerTrackerCubit(),
        child: BlocBuilder<PrayerTrackerCubit, PrayerTrackerState>(
          builder: (context, state) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _StreakCard(streak: state.streak, theme: theme),
                const SizedBox(height: 8),
                Center(
                  child: Text(state.date, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ),
                const SizedBox(height: 16),
                ...state.prayers.map((prayer) => _PrayerTile(prayer: prayer, theme: theme)),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _StreakCard extends StatelessWidget {
  final int streak;
  final ThemeData theme;
  const _StreakCard({required this.streak, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: streak > 0
              ? [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)]
              : [theme.colorScheme.surfaceContainerLow, theme.colorScheme.surfaceContainerLow],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: streak > 0
            ? [BoxShadow(color: theme.colorScheme.primary.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4))]
            : null,
      ),
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            streak > 0 ? Icons.local_fire_department : Icons.fireplace_outlined,
            color: streak > 0 ? Colors.orange : theme.colorScheme.onSurfaceVariant,
            size: 40,
          ),
          const SizedBox(width: 16),
          Column(
            children: [
              Text('$streak', style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: streak > 0 ? Colors.white : theme.colorScheme.onSurface,
              )),
              Text('Day Streak', style: theme.textTheme.bodyMedium?.copyWith(
                color: streak > 0 ? Colors.white70 : theme.colorScheme.onSurfaceVariant,
              )),
            ],
          ),
        ],
      ),
    );
  }
}

class _PrayerTile extends StatelessWidget {
  final PrayerStatus prayer;
  final ThemeData theme;
  const _PrayerTile({required this.prayer, required this.theme});

  @override
  Widget build(BuildContext context) {
    final performed = prayer.performed;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: performed ? theme.colorScheme.primaryContainer.withValues(alpha: 0.5) : theme.colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => context.read<PrayerTrackerCubit>().togglePrayer(prayer.name),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 28, height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: performed ? theme.colorScheme.primary : Colors.transparent,
                    border: Border.all(
                      color: performed ? theme.colorScheme.primary : theme.colorScheme.onSurfaceVariant,
                      width: 2,
                    ),
                  ),
                  child: performed ? const Icon(Icons.check, color: Colors.white, size: 16) : null,
                ),
                const SizedBox(width: 16),
                Text(
                  prayer.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: performed ? theme.colorScheme.onPrimaryContainer : theme.colorScheme.onSurface,
                  ),
                ),
                const Spacer(),
                if (performed)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text('Done', style: theme.textTheme.labelSmall?.copyWith(color: theme.colorScheme.primary, fontWeight: FontWeight.w600)),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
