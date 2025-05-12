import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/model/daily_quran_dua_model.dart';
import 'package:mm_muslim_support/module/home/cubit/daily_quran_dua_cubit.dart';
import 'package:mm_muslim_support/module/home/widgets/custom_card_widget.dart';
import 'package:mm_muslim_support/module/home/widgets/prayer_time_grid_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const PrayerTimeGrid(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: BlocProvider(
              create: (context) => DailyQuranDuaCubit(dailyDuaList),
              child: BlocBuilder<DailyQuranDuaCubit, DailyQuranDuaModel>(
                builder: (context, state) {
                  return DailyQuranDuaWidget(
                    title: 'Daily Dua',
                    dailyQuranDuaModel: state,
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: BlocProvider(
              create: (context) => DailyQuranDuaCubit(dailyQuranList),
              child: BlocBuilder<DailyQuranDuaCubit, DailyQuranDuaModel>(
                builder: (context, state) {
                  return DailyQuranDuaWidget(
                    title: 'Daily Quran Verse',
                    dailyQuranDuaModel: state,
                  );
                },
              ),
            ),
          ),
          // const SizedBox(height: 20),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text('History Articles', style: context.textTheme.titleMedium,),
          //       TextButtonWidget(text: 'See All', onPressed: () => context.navigateWithPushNamed(IslamicHistoryPage.routeName),),
          //     ],
          //   ),
          // ),
          // const SizedBox(height: 10),
          // Column(
          //   mainAxisSize: MainAxisSize.min,
          //   crossAxisAlignment: CrossAxisAlignment.start,
          //   children: historicalEvents.map((event) => IslamicHistoryWidget(event: event )).toList(),
          // )
        ],
      ),
    );
  }
}
