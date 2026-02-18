import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/core/routing/context_ext.dart';
import 'package:mm_muslim_support/module/home/cubit/ramadan_cubit/ramadan_cubit.dart';
import 'package:mm_muslim_support/module/quran/presentations/quran_list_page.dart';
import 'package:mm_muslim_support/module/ramadan/presentations/avoid_overeacting_page.dart';
import 'package:mm_muslim_support/module/ramadan/presentations/charity_and_sadaqah_page.dart';
import 'package:mm_muslim_support/module/ramadan/presentations/healty_suhoor_page.dart';
import 'package:mm_muslim_support/module/ramadan/presentations/hydrate_often_page.dart';
import 'package:mm_muslim_support/module/ramadan/presentations/taraweeh_page.dart';
import 'package:mm_muslim_support/utility/extensions.dart';
import 'package:mm_muslim_support/utility/ramadan_helper.dart';

class RamadanDashboardPage extends StatefulWidget {
  const RamadanDashboardPage({super.key});

  static const String routeName = '/ramadan_dashboard';

  @override
  State<RamadanDashboardPage> createState() => _RamadanDashboardPageState();
}

class _RamadanDashboardPageState extends State<RamadanDashboardPage> {
  // Example Sehri and Iftar times

  final completedDays = RamadanHelper.getCompletedDays();
  final totalRamadanDays = RamadanHelper.getTotalRamadanDays();
  final isRamadan = RamadanHelper.isRamadan();

  final List<String> dailyDuas = [
    'اللّهُمّ اجعل صيامي فيه صيام الصائمين وقيامي فيه قيام القائمين',
    'رَبِّ زِدْنِي عِلْمًا وَرَزُقْنِي تَقْوَى',
    'اللهم اجعلني من عتقاء شهر رمضان',
  ];

  final List<Map<String, String>> ramadanTips = [
    {'title': 'Healthy Suhoor', 'icon': '🥣', 'action' : HealthySuhoorPage.routeName},
    {'title': 'Hydrate Often', 'icon': '💧', 'action' : HydrateOftenScreen.routeName},
    {'title': 'Charity & Sadaqah', 'icon': '💚', 'action' : CharitySadaqahPage.routeName},
    {'title': 'Read Quran Daily', 'icon': '📖', 'action' : QuranListPage.routeName},
    {'title': 'Pray Taraweeh', 'icon': '🕌', 'action' : TaraweehPage.routeName},
    {'title': 'Avoid Overeating', 'icon': '🍎', 'action' : AvoidOvereatingPage.routeName},
  ];

  int currentDuaIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        children: [
          // Sehri/Iftar Countdown Card
          BlocProvider(
            create: (_) => RamadanCubit(),
            child: BlocBuilder<RamadanCubit, RamadanState>(
              builder: (context, state) {
                if (state.sehriTime == null || state.iftarTime == null) {
                  return const Center(child: CircularProgressIndicator());
                }
                // Use state.remainingTime
                final remainingTime = state.remainingTime;
                final hours = remainingTime.inHours.toString().padLeft(2, '0');
                final minutes = (remainingTime.inMinutes % 60).toString().padLeft(2, '0');
                final seconds = (remainingTime.inSeconds % 60).toString().padLeft(2, '0');

                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.deepPurple, Colors.purpleAccent],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 6,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.brightness_2, size: 48, color: Colors.white),
                      const SizedBox(height: 8),
                      Text(
                        // Use state.isSehriCountdown instead of DateTime.now()
                        "Next ${state.isSehriCountdown ? 'Sehri' : 'Iftar'}",
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        // Format duration as HH:mm:ss
                        '$hours:$minutes:$seconds',
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: Colors.yellowAccent,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),

          // Ramadan Tips Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: ramadanTips.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2,
            ),
            itemBuilder: (context, index) {
              final tip = ramadanTips[index];
              return InkWell(
                onTap: () => context.navigateWithPushNamed(tip['action']!),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.teal.shade400,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(tip['icon']!, style: const TextStyle(fontSize: 24)),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          tip['title']!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 16),

          // Ramadan Progress Tracker
          if (!isRamadan)
             const SizedBox() // Hide if not Ramadan
          else
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.indigoAccent,
                borderRadius: BorderRadius.circular(20),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'Ramadan Progress',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  LayoutBuilder(
                    builder: (context, constraints) {
                      final progress =
                          completedDays / totalRamadanDays;

                      return Stack(
                        children: [
                          Container(
                            height: 20,
                            width: constraints.maxWidth,
                            decoration: BoxDecoration(
                              color: Colors.white30,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          Container(
                            height: 20,
                            width: constraints.maxWidth * progress,
                            decoration: BoxDecoration(
                              color: Colors.yellowAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 8),

                  Text(
                    '$completedDays / $totalRamadanDays days completed',
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
