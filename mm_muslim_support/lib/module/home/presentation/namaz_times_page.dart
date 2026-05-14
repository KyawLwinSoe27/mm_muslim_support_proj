import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/core/routing/context_ext.dart';
import 'package:mm_muslim_support/model/custom_prayer_time.dart';
import 'package:mm_muslim_support/module/home/cubit/change_date_cubit.dart';
import 'package:mm_muslim_support/module/home/cubit/get_location_time_cubit/get_location_time_cubit.dart';
import 'package:mm_muslim_support/module/home/cubit/get_prayer_time_cubit/get_prayer_time_cubit.dart';
import 'package:mm_muslim_support/module/home/presentation/alarm_page.dart';
import 'package:mm_muslim_support/service/function_service.dart';
import 'package:mm_muslim_support/utility/image_constants.dart';

class NamazTimesPage extends StatelessWidget {
  const NamazTimesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) => GetLocationTimeCubit()..getLocationTime(),
      child: Column(
        children: [
          SizedBox(
            height: 170,
            child: Stack(
              children: [
                Container(
                  height: 170,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Opacity(opacity: 0.15, child: Image.asset(ImageConstants.beautifulMasjid, fit: BoxFit.cover)),
                ),
                const Positioned.fill(child: LocationAndTimeWidget()),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(color: theme.colorScheme.shadow.withValues(alpha: 0.06), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  const _PrayerDateHeader(),
                  const SizedBox(height: 8),
                  const Divider(height: 1),
                  Expanded(
                    child: BlocBuilder<GetPrayerTimeCubit, GetPrayerTimeState>(
                      buildWhen: (prev, current) =>
                          current is GetPrayerTimeByDateLoading ||
                          current is GetPrayerTimeByDateLoaded ||
                          current is GetPrayerTimeByDateError,
                      builder: (context, state) {
                        if (state is GetPrayerTimeByDateLoaded) {
                          return ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            itemCount: state.prayerTimes.length,
                            itemBuilder: (context, index) {
                              final pt = state.prayerTimes[index];
                              return _PrayerTimeRow(prayerTime: pt, index: index, theme: theme);
                            },
                          );
                        }
                        return const Center(child: CircularProgressIndicator());
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                    child: Row(
                      children: [
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.alarm_rounded,
                            label: 'Set Alarm',
                            color: theme.colorScheme.secondary,
                            onTap: () => context.navigateWithPushNamed(AlarmPage.routeName),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ActionButton(
                            icon: Icons.mosque_rounded,
                            label: 'Find Mosque',
                            color: theme.colorScheme.primary,
                            onTap: () => FunctionService.findNearbyMosque(context),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerDateHeader extends StatelessWidget {
  const _PrayerDateHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        IconButton(
          onPressed: () => context.read<ChangeDateCubit>().decrement(),
          icon: const Icon(Icons.chevron_left),
        ),
        Expanded(
          child: BlocBuilder<ChangeDateCubit, ChangeDateState>(
            builder: (context, state) => InkWell(
              onTap: () async {
                final cubit = context.read<ChangeDateCubit>();
                final date = await showDatePicker(context: context, initialDate: cubit.date, firstDate: DateTime(2000), lastDate: DateTime(2100));
                if (date != null) cubit.setDate(date);
              },
              borderRadius: BorderRadius.circular(8),
              child: Column(
                children: [
                  Text(state.gregorianDate, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                  Text(state.hijriDate, style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
                ],
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () => context.read<ChangeDateCubit>().increment(),
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class _PrayerTimeRow extends StatelessWidget {
  final CustomPrayerTime prayerTime;
  final int index;
  final ThemeData theme;
  const _PrayerTimeRow({required this.prayerTime, required this.index, required this.theme});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(prayerTime.prayerName.value, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
                if (index == 0)
                  Text('1-2 min gap, app uses 10 min safety', style: theme.textTheme.bodySmall?.copyWith(color: Colors.orange.shade700, fontSize: 10)),
              ],
            ),
          ),
          Text(prayerTime.prayerTime, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  const _ActionButton({required this.icon, required this.label, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
}

class LocationAndTimeWidget extends StatelessWidget {
  const LocationAndTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<GetLocationTimeCubit, GetLocationTimeState>(
      builder: (context, state) {
        if (state is GetLocationTimeLoaded) {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on_rounded, color: Colors.white.withValues(alpha: 0.8), size: 20),
                const SizedBox(height: 4),
                Text(state.location, style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w600), textAlign: TextAlign.center),
                const SizedBox(height: 4),
                Text(state.date, style: theme.textTheme.bodySmall?.copyWith(color: Colors.white70)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(20)),
                  child: Text('Current: ${state.currentPrayer}', style: theme.textTheme.bodySmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          );
        }
        return const SizedBox(height: 170, child: Center(child: CircularProgressIndicator(color: Colors.white)));
      },
    );
  }
}
