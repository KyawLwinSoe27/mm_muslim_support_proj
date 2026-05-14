import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/core/enums/prayer.dart';
import 'package:mm_muslim_support/core/routing/context_ext.dart';
import 'package:mm_muslim_support/module/home/cubit/alarm_cubit/alarm_cubit.dart';
import 'package:mm_muslim_support/module/home/presentation/notification_report_page.dart';

class AlarmPage extends StatelessWidget {
  const AlarmPage({super.key});

  static String routeName = '/alarm_page';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AlarmCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Prayer Alarm'),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () => context.navigateWithPushNamed(NotificationReportPage.routeName),
              icon: const Icon(Icons.list_alt_rounded),
            ),
          ],
        ),
        body: const _AlarmBody(),
      ),
    );
  }
}

class _AlarmBody extends StatelessWidget {
  const _AlarmBody();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<AlarmCubit, AlarmState>(
      builder: (context, state) {
        if (state is AlarmLoaded) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Text('Toggle alarms for each prayer time', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
              ),
              ...state.alarms.entries.map((entry) {
                final prayer = entry.key;
                final isEnabled = entry.value;
                final icon = _prayerIcon(prayer);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Material(
                    color: isEnabled ? theme.colorScheme.primaryContainer.withValues(alpha: 0.4) : theme.colorScheme.surfaceContainerLow,
                    borderRadius: BorderRadius.circular(16),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 44, height: 44,
                            decoration: BoxDecoration(
                              color: isEnabled ? theme.colorScheme.primary : theme.colorScheme.surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(icon, color: isEnabled ? Colors.white : theme.colorScheme.onSurfaceVariant, size: 22),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(prayer.name.toUpperCase(), style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                                Text(
                                  prayer == Prayer.sehri ? 'Before Fajr' : 'At prayer time',
                                  style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: isEnabled,
                            onChanged: (value) => context.read<AlarmCubit>().toggleAlarm(prayer, value),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  IconData _prayerIcon(Prayer prayer) {
    switch (prayer) {
      case Prayer.sehri: return Icons.nightlight_round;
      case Prayer.fajr: return Icons.wb_sunny_rounded;
      case Prayer.dhur: return Icons.wb_sunny_rounded;
      case Prayer.asr: return Icons.cloud_outlined;
      case Prayer.maghrib: return Icons.sunny;
      case Prayer.isha: return Icons.nightlight_round;
    }
  }
}
