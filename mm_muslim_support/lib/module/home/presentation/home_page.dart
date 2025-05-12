import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/model/tasbih_list_model.dart';
import 'package:mm_muslim_support/module/home/cubit/bottom_navigation_bar_cubit.dart';
import 'package:mm_muslim_support/module/home/cubit/change_date_cubit.dart';
import 'package:mm_muslim_support/module/home/cubit/get_prayer_time_cubit/get_prayer_time_cubit.dart';
import 'package:mm_muslim_support/module/tasbih/cubits/tasbih_counter_cubit.dart';
import 'package:mm_muslim_support/module/home/presentation/dashboard_page.dart';
import 'package:mm_muslim_support/module/home/presentation/namaz_times_page.dart';
import 'package:mm_muslim_support/module/home/presentation/tasbih_list_page.dart';
import 'package:mm_muslim_support/module/home/widgets/drawer_widget.dart';
import 'package:mm_muslim_support/module/home/widgets/today_date_widget.dart';
import 'package:mm_muslim_support/module/menu/cubit/get_location_cubit/get_location_cubit.dart';
import 'package:mm_muslim_support/module/stay_tuned_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  static String routeName = 'splash';

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return const DashboardPage();
      case 1:
        return MultiBlocProvider(
          providers: [
            BlocProvider<GetPrayerTimeCubit>(
              create: (context) => GetPrayerTimeCubit(),
            ),
            BlocProvider<ChangeDateCubit>(
              create:
                  (context) => ChangeDateCubit(
                    getPrayerTimeCubit: context.read<GetPrayerTimeCubit>(),
                  ),
            ),
          ],
          child: const NamazTimesPage(),
        );
      case 2:
        return BlocProvider(
          create: (context) => TasbihCounterCubit(),
          child: TasbihListPage(tasbihListModel: tasbihListModel),
        );
      case 3:
        return const Center(child: StayTunedPage());
      default:
        return const SizedBox.shrink(); // fallback
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) {
            return IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            );
          },
        ),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 10),
            child: TodayDateWidget(),
          ),
        ],
      ),
      drawer: BlocProvider(
        create: (context) => GetLocationCubit(),
        child: const DrawerWidget(),
      ),
      body: BlocBuilder<BottomNavigationBarCubit, int>(
        builder: (context, state) {
          return _buildPage(state);
        },
      ),
      bottomNavigationBar: BlocBuilder<BottomNavigationBarCubit, int>(
        builder: (context, state) {
          return BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: state,
            onTap: (index) {
              context.read<BottomNavigationBarCubit>().changePage(index);
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_rounded),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.mosque_rounded),
                label: 'Tracker',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.diamond_rounded),
                label: 'Tasbir',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.newspaper_rounded),
                label: 'Discover',
              ),
            ],
          );
        },
      ),
    );
  }
}
