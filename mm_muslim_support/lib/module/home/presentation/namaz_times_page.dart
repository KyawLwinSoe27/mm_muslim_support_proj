import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mm_muslim_support/main.dart';
import 'package:mm_muslim_support/model/custom_prayer_time.dart';
import 'package:mm_muslim_support/module/home/cubit/change_date_cubit.dart';
import 'package:mm_muslim_support/module/home/cubit/get_location_time_cubit/get_location_time_cubit.dart';
import 'package:mm_muslim_support/module/home/cubit/get_prayer_time_cubit/get_prayer_time_cubit.dart';
import 'package:mm_muslim_support/service/local_notification_service.dart';
import 'package:mm_muslim_support/service/notification_service.dart';
import 'package:mm_muslim_support/service/permission_service.dart';
import 'package:mm_muslim_support/utility/extensions.dart';
import 'package:mm_muslim_support/utility/image_constants.dart';

class NamazTimesPage extends StatelessWidget {
  const NamazTimesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const BackgroundWidget(),

        Column(
          children: [
            const LocationAndTimeWidget(),

            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(color: context.colorScheme.surface, borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    const PrayerDateWidget(),
                    const SizedBox(height: 20),
                    Expanded(
                      child: Column(
                        children: [
                          // Header row
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  width: 70,
                                    child: Text('Prayer', style: TextStyle(fontWeight: FontWeight.bold))),
                                Text('Time', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text('Notify', style: TextStyle(fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Divider(height: 1),
                          const SizedBox(height: 5),
                          // List of prayer times
                          Expanded(
                            child: BlocBuilder<GetPrayerTimeCubit, GetPrayerTimeState>(
                              buildWhen: (prev, current) {
                                return current is GetPrayerTimeByDateLoading || current is GetPrayerTimeByDateLoaded || current is GetPrayerTimeByDateError;
                              },
                              builder: (context, state) {
                                if (state is GetPrayerTimeByDateLoaded) {
                                  return ListView.builder(
                                    itemCount: 5, // Replace with your actual prayer times count
                                    itemBuilder: (context, index) {
                                      CustomPrayerTime prayerTime = state.prayerTimes[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            SizedBox(
                                              width: 70,
                                              child: Text(
                                                prayerTime.prayerName, // Replace with dynamic prayer name
                                                style: Theme.of(context).textTheme.titleMedium,
                                              ),
                                            ),
                                            Text(
                                              prayerTime.prayerTime, // Replace with dynamic time
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
                                            ElevatedButton(
                                              onPressed: () async{
                                                final now = DateTime.now();
                                                NotificationService.scheduleDailyReminder(
                                                  hour: now.hour,
                                                  minute: now.minute + 1, // ⏱ fire in 1 minute
                                                  title: "Test Reminder",
                                                  body: "This is a test notification",
                                                  notificationId: now.microsecond,
                                                );
                                                ScaffoldMessenger.of(context).showSnackBar(
                                                  const SnackBar(content: Text("Fajr reminder set!")),
                                                );
                                                flutterLocalNotificationsPlugin.pendingNotificationRequests().then((requests) {
                                                  print("Pending notifications: ${requests.length}");
                                                  for (var req in requests) {
                                                    print("Notification: ${req.id} - ${req.title} at ${req.body}");
                                                  }
                                                });

                                                await flutterLocalNotificationsPlugin.show(
                                                  101,
                                                  'Immediate Test',
                                                  'This should play sound',
                                                  const NotificationDetails(
                                                    android: AndroidNotificationDetails(
                                                      'daily_reminder_channel',
                                                      'Test Notifications',
                                                      importance: Importance.max,
                                                      priority: Priority.high,
                                                      playSound: true,
                                                      sound: RawResourceAndroidNotificationSound('azan'), // or leave null
                                                    ),
                                                    iOS: DarwinNotificationDetails(
                                                      presentSound: true,
                                                      sound: 'azan.mp3',
                                                    ),
                                                  ),
                                                );

                                              },
                                              child: const Text("Set Fajr Reminder"),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  return const Center(child: CircularProgressIndicator());
                                }
                              },
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
      ],
    );
  }
}

class PrayerDateWidget extends StatelessWidget {
  const PrayerDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () async {
            ChangeDateCubit changeDateCubit = context.read<ChangeDateCubit>();
            changeDateCubit.decrement();
          },
          icon: const Icon(Icons.chevron_left),
        ),
        BlocBuilder<ChangeDateCubit, ChangeDateState>(
          builder: (context, state) {
            return Expanded(
              child: InkWell(
                onTap: () async {
                  ChangeDateCubit changeDateCubit = context.read<ChangeDateCubit>();
                  GetPrayerTimeCubit getPrayerTimeCubit = context.read<GetPrayerTimeCubit>();
                  DateTime? selectedDate = await showDatePicker(context: context, initialDate: context.read<ChangeDateCubit>().date, firstDate: DateTime(2000), lastDate: DateTime(2100));
                  if (selectedDate != null) {
                    changeDateCubit.setDate(selectedDate);
                  }
                },
                child: Column(
                  children: [
                    Text(state.gregorianDate, style: context.textTheme.titleMedium?.copyWith(color: context.colorScheme.onSurface)),
                    Text(state.hijriDate, style: context.textTheme.titleMedium?.copyWith(color: context.colorScheme.onSurface)),
                  ],
                ),
              ),
            );
          },
        ),
        IconButton(
          onPressed: () async {
            ChangeDateCubit changeDateCubit = context.read<ChangeDateCubit>();
            changeDateCubit.increment();
          },
          icon: const Icon(Icons.chevron_right),
        ),
      ],
    );
  }
}

class LocationAndTimeWidget extends StatelessWidget {
  const LocationAndTimeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
  create: (context) => GetLocationTimeCubit()..getLocationTime(),
  child: BlocBuilder<GetLocationTimeCubit, GetLocationTimeState>(
  builder: (context, state) {
    if(state is GetLocationTimeLoaded) {
      return SizedBox(
        height: 150,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Location: ${state.location}', style: context.textTheme.titleMedium?.copyWith(color: context.colorScheme.onSecondary)),
              const SizedBox(height: 10),
              Text('Today\'s Date: ${state.date}', style: context.textTheme.titleSmall?.copyWith(color: context.colorScheme.onSecondary)),
              const SizedBox(height: 10),
              Text('Current Prayer: ${state.currentPrayer}', style: context.textTheme.titleSmall?.copyWith(color: context.colorScheme.onSecondary)),
            ],
          ),
        ),
      );
    } else {
      return const SizedBox(
        height: 150,
        child: Center(child: CircularProgressIndicator()),
      );
    }
  },
),
);
  }
}

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 200,
          child: Stack(
            children: [
              Container(height: 200, decoration: BoxDecoration(color: context.colorScheme.secondary)),
              Opacity(opacity: 0.2, child: Image.asset(ImageConstants.beautifulMasjid, fit: BoxFit.cover)),
            ],
          ),
        ),
        Expanded(child: Container(color: context.colorScheme.surface)),
        // Add your namaz times list here
      ],
    );
  }
}
