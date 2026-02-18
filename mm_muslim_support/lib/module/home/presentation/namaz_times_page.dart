import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/core/routing/context_ext.dart';
import 'package:mm_muslim_support/model/custom_prayer_time.dart';
import 'package:mm_muslim_support/module/home/cubit/change_date_cubit.dart';
import 'package:mm_muslim_support/module/home/cubit/get_location_time_cubit/get_location_time_cubit.dart';
import 'package:mm_muslim_support/module/home/cubit/get_prayer_time_cubit/get_prayer_time_cubit.dart';
import 'package:mm_muslim_support/module/home/presentation/alarm_page.dart';
import 'package:mm_muslim_support/service/function_service.dart';
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
                decoration: BoxDecoration(
                  color: context.colorScheme.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: context.colorScheme.onSurface.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
                    BoxShadow(color: context.colorScheme.onSurface.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
                    BoxShadow(color: context.colorScheme.onSurface.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
                    BoxShadow(color: context.colorScheme.onSurface.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4)),
                  ],
                ),
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
                              children: [SizedBox(width: 70, child: Text('Prayer', style: TextStyle(fontWeight: FontWeight.bold))), Text('Time', style: TextStyle(fontWeight: FontWeight.bold))],
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
                                    itemCount: state.prayerTimes.length, // Replace with your actual prayer times count
                                    itemBuilder: (context, index) {
                                      CustomPrayerTime prayerTime = state.prayerTimes[index];
                                      return Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 13.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Text(
                                                    prayerTime.prayerName.value, // Replace with dynamic prayer name
                                                    style: Theme.of(context).textTheme.titleMedium,
                                                  ),
                                                  Visibility(
                                                    visible: index == 0,
                                                    child:  const Text('Some scholars allow 1–2 minutes gap; this app uses 10 minutes for safety', style: TextStyle(color: Colors.red, fontSize: 10)),)
                                                ],
                                              ),
                                            ),
                                            Text(
                                              prayerTime.prayerTime, // Replace with dynamic time
                                              style: Theme.of(context).textTheme.titleMedium,
                                            ),
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
                          const SizedBox(height: 10),
                          TextButton(
                            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(context.colorScheme.secondary), foregroundColor: WidgetStateProperty.all(context.colorScheme.onPrimary)),
                            onPressed: () =>  context.navigateWithPushNamed(
                                AlarmPage.routeName),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.alarm),
                                SizedBox(width: 10,),
                                Text('Set Prayer Alarm'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextButton(
                            style: ButtonStyle(backgroundColor: WidgetStateProperty.all(context.colorScheme.primary), foregroundColor: WidgetStateProperty.all(context.colorScheme.onPrimary)),
                            onPressed: () => FunctionService.findNearbyMosque(context),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.mosque),
                                SizedBox(width: 10,),
                                Text('Find Near Mosque'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 5),
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
          if (state is GetLocationTimeLoaded) {
            return SizedBox(
              height: 150,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Location: ${state.location}', style: context.textTheme.titleMedium?.copyWith(color: context.colorScheme.onSecondary), textAlign: TextAlign.center),
                    const SizedBox(height: 10),
                    Text('Today\'s Date: ${state.date}', style: context.textTheme.titleSmall?.copyWith(color: context.colorScheme.onSecondary)),
                    const SizedBox(height: 10),
                    Text('Current Prayer: ${state.currentPrayer}', style: context.textTheme.titleSmall?.copyWith(color: context.colorScheme.onSecondary)),
                  ],
                ),
              ),
            );
          } else {
            return const SizedBox(height: 150, child: Center(child: CircularProgressIndicator()));
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
