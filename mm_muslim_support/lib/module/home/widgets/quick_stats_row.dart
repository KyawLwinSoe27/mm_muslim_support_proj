import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/module/home/cubit/prayer_tracker_cubit.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class QuickStatsRow extends StatelessWidget {
  const QuickStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTrackerCubit, PrayerTrackerState>(
      builder: (context, state) {
        final completed = state.prayers.where((p) => p.performed).length;
        final total = state.prayers.length;
        final percent = total > 0 ? (completed / total * 100).round() : 0;

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(child: _StatCard(
                icon: Icons.check_circle_rounded,
                label: 'Today',
                value: '$completed/$total',
                color: context.colorScheme.primary,
              )),
              Expanded(child: _StatCard(
                icon: Icons.local_fire_department_rounded,
                label: 'Streak',
                value: '${state.streak}',
                color: Colors.orangeAccent,
              )),
              Expanded(child: _StatCard(
                icon: Icons.trending_up_rounded,
                label: 'Rate',
                value: '$percent%',
                color: context.colorScheme.secondary,
              )),
            ],
          ),
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20, color: color),
          const SizedBox(height: 4),
          Text(
            value,
            style: context.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          Text(
            label,
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
