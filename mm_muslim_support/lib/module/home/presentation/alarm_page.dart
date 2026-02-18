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
      create: (_) => AlarmCubit()..setContext(context),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Prayer Alarm Settings'),
          centerTitle: true,
          actions: [
            IconButton(onPressed: () => context.navigateWithPushNamed(NotificationReportPage.routeName), icon: const Icon(Icons.list))

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
    return BlocBuilder<AlarmCubit, AlarmState>(
      builder: (context, state) {
        if (state is AlarmLoaded) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: state.alarms.entries.map((entry) {
              final prayer = entry.key;
              final isEnabled = entry.value;

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                margin: const EdgeInsets.only(bottom: 12),
                child: SwitchListTile(
                  title: Text(
                    prayer.name.toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(prayer == Prayer.sehri
                      ? 'Enable notification before Fajr'
                      : 'Enable notification at prayer time'),
                  value: isEnabled,
                  onChanged: (value) {
                    context.read<AlarmCubit>().toggleAlarm(prayer, value);
                  },
                ),
              );
            }).toList(),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
