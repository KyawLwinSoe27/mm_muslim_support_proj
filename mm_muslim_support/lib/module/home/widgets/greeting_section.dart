import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/module/home/cubit/get_hijri_date_cubit/get_hijri_date_cubit.dart';
import 'package:mm_muslim_support/module/home/cubit/prayer_tracker_cubit.dart';
import 'package:mm_muslim_support/service/location_service.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class GreetingSection extends StatelessWidget {
  const GreetingSection({super.key});

  @override
  Widget build(BuildContext context) {
    final city = LocationService.getLocationName();

    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            context.colorScheme.primary,
            context.colorScheme.primary.withValues(alpha: 0.8),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: context.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Assalamu Alaikum',
                      style: context.textTheme.titleLarge?.copyWith(
                        color: context.colorScheme.onPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    BlocBuilder<GetHijriDateCubit, GetHijriDateState>(
                      builder: (context, state) {
                        if (state is GetHijriDateLoaded) {
                          return Text(
                            '${state.todayDate.gregorianDate}  •  ${state.todayDate.hijriDate}',
                            style: context.textTheme.bodySmall?.copyWith(
                              color: context.colorScheme.onPrimary.withValues(alpha: 0.85),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.location_on_rounded,
                color: context.colorScheme.onPrimary.withValues(alpha: 0.9),
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                city,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onPrimary.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          BlocBuilder<PrayerTrackerCubit, PrayerTrackerState>(
            builder: (context, state) {
              return Row(
                children: [
                  _StreakBadge(streak: state.streak),
                  const SizedBox(width: 8),
                  _PrayerProgressBadge(
                    completed: state.prayers.where((p) => p.performed).length,
                    total: state.prayers.length,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _StreakBadge extends StatelessWidget {
  final int streak;
  const _StreakBadge({required this.streak});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.colorScheme.onPrimary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_fire_department_rounded, size: 16, color: Colors.orangeAccent),
          const SizedBox(width: 4),
          Text(
            '$streak-day streak',
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerProgressBadge extends StatelessWidget {
  final int completed;
  final int total;
  const _PrayerProgressBadge({required this.completed, required this.total});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.colorScheme.onPrimary.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check_circle_rounded, size: 16, color: context.colorScheme.onPrimary),
          const SizedBox(width: 4),
          Text(
            '$completed/$total prayers',
            style: context.textTheme.labelSmall?.copyWith(
              color: context.colorScheme.onPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
