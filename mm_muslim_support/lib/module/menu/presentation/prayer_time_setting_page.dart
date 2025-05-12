import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/model/prayer_calculation_method.dart';
import 'package:mm_muslim_support/module/menu/cubit/get_madhab_cubit.dart';
import 'package:mm_muslim_support/module/menu/cubit/get_prayer_calculation_method_cubit.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class PrayerTimeSettingPage extends StatelessWidget {
  const PrayerTimeSettingPage({super.key});

  static const String routeName = 'prayerSettingPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Prayer Time Settings', style: context.textTheme.titleLarge?.copyWith(color: context.colorScheme.onSecondary, fontWeight: FontWeight.w500))),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          const SizedBox(height: 30),
          LayoutBuilder(
            builder: (context, constraints) {
              return BlocBuilder<GetPrayerCalculationMethodCubit, PrayerCalculationMethod>(
                builder: (context, state) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    child: DropdownButtonFormField<PrayerCalculationMethod>(
                      isExpanded: true, // <--- IMPORTANT
                      menuMaxHeight: 300,
                      value: state,
                      decoration: const InputDecoration(labelText: 'Calculation Method', border: OutlineInputBorder()),
                      items:
                          prayerCalculationMethods.map((method) {
                            return DropdownMenuItem<PrayerCalculationMethod>(value: method, child: Text(method.name, overflow: TextOverflow.ellipsis, maxLines: 1));
                          }).toList(),
                      onChanged: (value) => context.read<GetPrayerCalculationMethodCubit>().choosePrayerCalculationMethod(value),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: ListTile(
                  leading: const Icon(Icons.mosque),
                  title: const Text('Madhab'),
                  onTap: () {
                    // Navigate to language selection screen
                  },
                ),
              ),
              BlocProvider(
                create: (context) => GetMadhabCubit()..setMadhab(SharedPreferenceService.getMadhab() ?? true),
                child: BlocBuilder<GetMadhabCubit, bool>(
                  builder: (context, state) {
                    return Row(children: [const Text('Shafi'), Switch(value: state, onChanged: (value) => context.read<GetMadhabCubit>()..toggleMadhab()), const Text('Hanafi')]);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
