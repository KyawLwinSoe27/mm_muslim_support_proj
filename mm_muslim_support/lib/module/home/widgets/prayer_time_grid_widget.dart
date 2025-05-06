import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/module/home/cubit/get_prayer_time_cubit/get_prayer_time_cubit.dart';

class PrayerTimeGrid extends StatelessWidget {
  const PrayerTimeGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetPrayerTimeCubit()..getPrayerTime(),
      child: BlocBuilder<GetPrayerTimeCubit, GetPrayerTimeState>(
        buildWhen: (prev, current) {
          return current is GetPrayerTimeLoading || current is GetPrayerTimeLoaded || current is GetPrayerTimeError;
        },
        builder: (context, state) {
          if (state is GetPrayerTimeLoaded) {
            return SizedBox(
              height: state.prayerTimes.length > 2 ? 300 : 150,
              width: double.infinity,
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(12),
                itemCount: state.prayerTimes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 1.3),
                itemBuilder: (context, index) {
                  final card = state.prayerTimes[index];
                  return Container(
                    decoration: BoxDecoration(gradient: LinearGradient(colors: card.gradientColors, begin: Alignment.topCenter, end: Alignment.bottomCenter), borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(card.title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                        const SizedBox(height: 4),
                        Text(card.subtitle ?? card.time, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Colors.black)),
                        const Spacer(),
                        if (card.image.isNotEmpty) Align(alignment: Alignment.centerRight, child: Image.asset(card.image, height: 48)),
                        if (card.subtitle != null) Text(card.time, style: const TextStyle(color: Colors.black)),
                      ],
                    ),
                  );
                },
              ),
            );
          } else if (state is GetPrayerTimeLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetPrayerTimeError) {
            return const Center(child: Text('Error loading prayer times'));
          } else {
            return const Center(child: Text('No prayer times available'));
          }
        },
      ),
    );
  }
}
