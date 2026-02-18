import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/common/cubit/hijri_offset_cubit.dart';
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
      appBar: AppBar(
        title: Text(
          'Prayer Time Settings',
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colorScheme.onSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: [
          const SizedBox(height: 30),
          LayoutBuilder(
            builder: (context, constraints) {
              return BlocBuilder<
                GetPrayerCalculationMethodCubit,
                PrayerCalculationMethod
              >(
                builder: (context, state) {
                  return SizedBox(
                    width: constraints.maxWidth,
                    child: DropdownButtonFormField<PrayerCalculationMethod>(
                      isExpanded: true, // <--- IMPORTANT
                      menuMaxHeight: 300,
                      value: state,
                      decoration: const InputDecoration(
                        labelText: 'Calculation Method',
                        border: OutlineInputBorder(),
                      ),
                      items:
                          prayerCalculationMethods.map((method) {
                            return DropdownMenuItem<PrayerCalculationMethod>(
                              value: method,
                              child: Text(
                                method.name,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            );
                          }).toList(),
                      onChanged:
                          (value) => context
                              .read<GetPrayerCalculationMethodCubit>()
                              .choosePrayerCalculationMethod(value),
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
                create:
                    (context) =>
                        GetMadhabCubit()..setMadhab(
                          SharedPreferenceService.getMadhab() ?? true,
                        ),
                child: BlocBuilder<GetMadhabCubit, bool>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        const Text('Shafi'),
                        Switch(
                          value: state,
                          onChanged:
                              (value) =>
                                  context.read<GetMadhabCubit>()
                                    ..toggleMadhab(),
                        ),
                        const Text('Hanafi'),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),

          BlocBuilder<HijriOffsetCubit, int>(
            builder: (context, offset) {
              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Hijri Date Adjustment',
                        style: context.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Adjust Islamic date based on local moon sighting.',
                        style: context.textTheme.bodySmall,
                      ),
                      const SizedBox(height: 16),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [

                          IconButton(
                            onPressed: () =>
                                context.read<HijriOffsetCubit>().decrease(),
                            icon: const Icon(Icons.remove_circle_outline),
                          ),

                          Text(
                            offset == 0
                                ? 'No Adjustment'
                                : offset > 0
                                ? '+$offset Day'
                                : '$offset Day',
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          IconButton(
                            onPressed: () =>
                                context.read<HijriOffsetCubit>().increase(),
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      Center(
                        child: TextButton(
                          onPressed: () =>
                              context.read<HijriOffsetCubit>().reset(),
                          child: const Text('Reset to Default'),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
