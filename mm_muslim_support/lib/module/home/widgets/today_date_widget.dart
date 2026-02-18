import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/module/home/cubit/get_hijri_date_cubit/get_hijri_date_cubit.dart';

class TodayDateWidget extends StatelessWidget {
  const TodayDateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetHijriDateCubit, GetHijriDateState>(
      builder: (context, state) {
        if (state is GetHijriDateLoaded) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                state.todayDate.gregorianDate,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              Text(
                state.todayDate.hijriDate,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
