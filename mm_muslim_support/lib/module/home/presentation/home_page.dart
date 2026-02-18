import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/model/tasbih_list_model.dart';
import 'package:mm_muslim_support/module/history/presentations/history_timeline_page.dart';
import 'package:mm_muslim_support/module/home/cubit/bottom_navigation_bar_cubit.dart';
import 'package:mm_muslim_support/module/home/cubit/change_date_cubit.dart';
import 'package:mm_muslim_support/module/home/cubit/get_hijri_date_cubit/get_hijri_date_cubit.dart';
import 'package:mm_muslim_support/module/home/cubit/get_prayer_time_cubit/get_prayer_time_cubit.dart';
import 'package:mm_muslim_support/module/home/presentation/ramadan_dashboard_page.dart';
import 'package:mm_muslim_support/module/tasbih/cubits/tasbih_counter_cubit.dart';
import 'package:mm_muslim_support/module/home/presentation/namaz_times_page.dart';
import 'package:mm_muslim_support/module/home/presentation/tasbih_list_page.dart';
import 'package:mm_muslim_support/module/home/widgets/drawer_widget.dart';
import 'package:mm_muslim_support/module/home/widgets/today_date_widget.dart';
import 'package:mm_muslim_support/module/menu/cubit/get_location_cubit/get_location_cubit.dart';
import 'package:mm_muslim_support/module/stay_tuned_page.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  static String routeName = 'splash';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  final List<HistoryEvent> islamicHistoryEvents = [
    HistoryEvent(
      id: '1',
      title: 'Birth of Prophet Muhammad ﷺ',
      description: 'Prophet Muhammad ﷺ was born in Mecca in the Year of the Elephant.',
      startDate: DateTime(570),
    ),
    HistoryEvent(
      id: '2',
      title: 'First Revelation',
      description: 'Prophet Muhammad ﷺ received the first revelation in Cave Hira.',
      startDate: DateTime(610),
    ),
    HistoryEvent(
      id: '3',
      title: 'Start of Da’wah',
      description: 'Prophet ﷺ began publicly calling people to Islam.',
      startDate: DateTime(613),
    ),
    HistoryEvent(
      id: '4',
      title: 'Migration to Abyssinia',
      description: 'Some Muslims migrated to Abyssinia to escape persecution.',
      startDate: DateTime(615),
    ),
    HistoryEvent(
      id: '5',
      title: 'Isra and Mi’raj',
      description: 'Prophet ﷺ traveled to Jerusalem and ascended to the heavens.',
      startDate: DateTime(620),
    ),
    HistoryEvent(
      id: '6',
      title: 'Hijrah (Migration to Medina)',
      description: 'The Prophet ﷺ and companions migrated from Mecca to Medina.',
      startDate: DateTime(622),
    ),
    HistoryEvent(
      id: '7',
      title: 'Battle of Badr',
      description: 'First major battle between Muslims and Quraysh.',
      startDate: DateTime(624),
    ),
    HistoryEvent(
      id: '8',
      title: 'Battle of Uhud',
      description: 'Second battle between Muslims and Quraysh in Medina.',
      startDate: DateTime(625),
    ),
    HistoryEvent(
      id: '9',
      title: 'Battle of the Trench',
      description: 'Muslims defended Medina with a trench during siege by Quraysh.',
      startDate: DateTime(627),
    ),
    HistoryEvent(
      id: '10',
      title: 'Treaty of Hudaybiyyah',
      description: 'Peace treaty between Muslims and Quraysh of Mecca.',
      startDate: DateTime(628),
    ),
    HistoryEvent(
      id: '11',
      title: 'Conquest of Mecca',
      description: 'Prophet ﷺ peacefully conquered Mecca.',
      startDate: DateTime(630),
    ),
    HistoryEvent(
      id: '12',
      title: 'Farewell Pilgrimage',
      description: 'Prophet ﷺ performed his final pilgrimage to Mecca.',
      startDate: DateTime(632),
    ),
    HistoryEvent(
      id: '13',
      title: 'Death of Prophet Muhammad ﷺ',
      description: 'The Prophet ﷺ passed away in Medina.',
      startDate: DateTime(632),
    ),
    HistoryEvent(
      id: '14',
      title: 'Caliph Abu Bakr ﷺ',
      description: 'Abu Bakr became the first caliph after Prophet ﷺ.',
      startDate: DateTime(632),
      endDate: DateTime(634),
    ),
    HistoryEvent(
      id: '15',
      title: 'Caliph Umar ibn al-Khattab ﷺ',
      description: 'Second caliph, expanded the Islamic state significantly.',
      startDate: DateTime(634),
      endDate: DateTime(644),
    ),
    HistoryEvent(
      id: '16',
      title: 'Caliph Uthman ibn Affan ﷺ',
      description: 'Third caliph, known for compilation of the Quran.',
      startDate: DateTime(644),
      endDate: DateTime(656),
    ),
    HistoryEvent(
      id: '17',
      title: 'Caliph Ali ibn Abi Talib ﷺ',
      description: 'Fourth caliph, known for wisdom and justice.',
      startDate: DateTime(656),
      endDate: DateTime(661),
    ),
    HistoryEvent(
      id: '18',
      title: 'Foundation of Baghdad',
      description: 'Abbasid Caliphate established Baghdad as its capital.',
      startDate: DateTime(762),
    ),
    HistoryEvent(
      id: '19',
      title: 'Golden Age of Islam',
      description: 'Flourishing of science, medicine, literature, and philosophy.',
      startDate: DateTime(800),
      endDate: DateTime(1258),
    ),
    HistoryEvent(
      id: '20',
      title: 'Mongol Siege of Baghdad',
      description: 'End of Abbasid Caliphate after Mongol invasion.',
      startDate: DateTime(1258),
    ),
  ];



  @override
  void dispose() {
    _refreshController.dispose();
    super.dispose();
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return BlocBuilder<GetHijriDateCubit, GetHijriDateState>(
          builder: (context, state) {
            return const RamadanDashboardPage();
          },
        );
      case 1:
        return MultiBlocProvider(
          providers: [
            BlocProvider<GetPrayerTimeCubit>(
              create: (context) => GetPrayerTimeCubit(),
            ),
            BlocProvider<ChangeDateCubit>(
              create:
                  (context) =>
                  ChangeDateCubit(
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
        return Center(child: HistoryTimelinePage(events: islamicHistoryEvents,));
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
      body: BlocListener<GetHijriDateCubit, GetHijriDateState>(
        listener: (context, state) {
          if (state is GetHijriDateLoaded) {
            _refreshController.refreshCompleted();
          }

          if (state is GetHijriDateError) {
            _refreshController.refreshFailed();
          }
        },
        child: BlocBuilder<BottomNavigationBarCubit, int>(
          builder: (context, state) {
            return SmartRefresher(
                enablePullDown: true,
                onRefresh: () {
                  context.read<GetHijriDateCubit>().getTodayDate();
                },
                header: const WaterDropHeader(),
                controller: _refreshController,

                child: _buildPage(state));
          },
        ),
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
