import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/module/home/cubit/get_prayer_time_cubit/get_prayer_time_cubit.dart';
import 'package:mm_muslim_support/module/home/cubit/prayer_tracker_cubit.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class PrayerSection extends StatelessWidget {
  const PrayerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _NextPrayerCountdown(),
        const SizedBox(height: 12),
        const _PrayerChecklist(),
      ],
    );
  }
}

class _NextPrayerCountdown extends StatefulWidget {
  const _NextPrayerCountdown();

  @override
  State<_NextPrayerCountdown> createState() => _NextPrayerCountdownState();
}

class _NextPrayerCountdownState extends State<_NextPrayerCountdown> {
  Timer? _timer;
  Duration _remaining = Duration.zero;
  String _nextPrayerName = '';

  @override
  void initState() {
    super.initState();
    _updateCountdown();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateCountdown());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _updateCountdown() {
    final cubit = context.read<GetPrayerTimeCubit>();
    final state = cubit.state;
    if (state is GetPrayerTimeLoaded && state.prayerTimes.length >= 4) {
      final lastCard = state.prayerTimes.last;
      final nextName = lastCard.subtitle ?? '';
      final timeStr = lastCard.time.replaceAll('Start ', '');
      if (nextName.isNotEmpty && timeStr.isNotEmpty && timeStr != '--:--') {
        final now = DateTime.now();
        final parts = timeStr.split(':');
        if (parts.length == 2) {
          final hour = int.tryParse(parts[0]) ?? 0;
          final minute = int.tryParse(parts[1]) ?? 0;
          var nextTime = DateTime(now.year, now.month, now.day, hour, minute);
          if (nextTime.isBefore(now)) {
            nextTime = nextTime.add(const Duration(days: 1));
          }
          final remaining = nextTime.difference(now);
          if (remaining != _remaining || nextName != _nextPrayerName) {
            setState(() {
              _remaining = remaining;
              _nextPrayerName = nextName;
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_nextPrayerName.isEmpty) return const SizedBox.shrink();

    final hours = _remaining.inHours;
    final minutes = _remaining.inMinutes.remainder(60);
    final seconds = _remaining.inSeconds.remainder(60);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(Icons.timer_outlined, color: context.colorScheme.primary, size: 20),
          const SizedBox(width: 8),
          Text(
            '$_nextPrayerName in ',
            style: context.textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
          ),
          Text(
            '${hours}h ${minutes.toString().padLeft(2, '0')}m ${seconds.toString().padLeft(2, '0')}s',
            style: context.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: context.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerChecklist extends StatelessWidget {
  const _PrayerChecklist();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PrayerTrackerCubit, PrayerTrackerState>(
      builder: (context, state) {
        final prayers = state.prayers;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: prayers.map((p) {
              final performed = p.performed;
              return Expanded(
                child: GestureDetector(
                  onTap: () => context.read<PrayerTrackerCubit>().togglePrayer(p.name),
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: performed
                          ? context.colorScheme.primaryContainer
                          : context.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(14),
                      border: performed
                          ? Border.all(color: context.colorScheme.primary, width: 1.5)
                          : null,
                    ),
                    child: Column(
                      children: [
                        Icon(
                          performed ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                          size: 20,
                          color: performed
                              ? context.colorScheme.primary
                              : context.colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _shortName(p.name),
                          style: context.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: performed
                                ? context.colorScheme.primary
                                : context.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        );
      },
    );
  }

  String _shortName(String name) {
    switch (name.toLowerCase()) {
      case 'fajr': return 'Fajr';
      case 'dhuhr': return 'Zuhr';
      case 'asr': return 'Asr';
      case 'maghrib': return 'Magh';
      case 'isha': return 'Isha';
      default: return name;
    }
  }
}
