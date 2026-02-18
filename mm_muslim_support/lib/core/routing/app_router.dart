import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mm_muslim_support/common/bloc/download_file_bloc/download_file_bloc.dart';
import 'package:mm_muslim_support/common/cubit/hijri_offset_cubit.dart';
import 'package:mm_muslim_support/core/enums/folder.dart';
import 'package:mm_muslim_support/model/quran_song_model.dart';
import 'package:mm_muslim_support/model/tasbih_model.dart';
import 'package:mm_muslim_support/module/history/presentations/history_timeline_page.dart';
import 'package:mm_muslim_support/module/history/presentations/islamic_history_page.dart';
import 'package:mm_muslim_support/module/home/cubit/bottom_navigation_bar_cubit.dart';
import 'package:mm_muslim_support/module/home/cubit/get_hijri_date_cubit/get_hijri_date_cubit.dart';
import 'package:mm_muslim_support/module/home/presentation/alarm_page.dart';
import 'package:mm_muslim_support/module/home/presentation/notification_report_page.dart';
import 'package:mm_muslim_support/module/ramadan/presentations/avoid_overeacting_page.dart';
import 'package:mm_muslim_support/module/ramadan/presentations/charity_and_sadaqah_page.dart';
import 'package:mm_muslim_support/module/ramadan/presentations/healty_suhoor_page.dart';
import 'package:mm_muslim_support/module/ramadan/presentations/hydrate_often_page.dart';
import 'package:mm_muslim_support/module/ramadan/presentations/taraweeh_page.dart';
import 'package:mm_muslim_support/module/tasbih/cubits/tasbih_counter_cubit.dart';
import 'package:mm_muslim_support/module/home/presentation/home_page.dart';
import 'package:mm_muslim_support/module/menu/cubit/get_prayer_calculation_method_cubit.dart';
import 'package:mm_muslim_support/module/menu/presentation/about_us_screen.dart';
import 'package:mm_muslim_support/module/menu/presentation/compass_page.dart';
import 'package:mm_muslim_support/module/menu/presentation/donate_us_screen.dart';
import 'package:mm_muslim_support/module/menu/presentation/logs_page.dart';
import 'package:mm_muslim_support/module/menu/presentation/prayer_time_setting_page.dart';
import 'package:mm_muslim_support/module/notification/presentations/notification_page.dart';
import 'package:mm_muslim_support/module/quran/bloc/audio_player_cubit/audio_player_cubit.dart';
import 'package:mm_muslim_support/module/quran/cubit/book_mark_cubit/book_mark_cubit.dart';
import 'package:mm_muslim_support/module/quran/presentations/quran_list_page.dart';
import 'package:mm_muslim_support/module/quran/presentations/quran_screen.dart';
import 'package:mm_muslim_support/module/quran/presentations/surah_listen_list.dart';
import 'package:mm_muslim_support/module/quran/presentations/surah_listen_page.dart';
import 'package:mm_muslim_support/module/stay_tuned_page.dart';
import 'package:mm_muslim_support/module/tasbih/presentations/tasbih_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Home Route
      GoRoute(
        name: HomePage.routeName,
        path: '/',
        builder:
            (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => GetHijriDateCubit()..getTodayDate(),
                ),
                BlocProvider(
                  create: (context) => BottomNavigationBarCubit(),
                ),
              ],
              child: const HomePage(),
            ),
      ),
      GoRoute(
        name: IslamicHistoryPage.routeName,
        path: '/history',
        builder: (context, state) => const IslamicHistoryPage(),
      ),
      // Login Route
      GoRoute(
        name: PrayerTimeSettingPage.routeName,
        path: '/prayerSettingPage',
        builder:
            (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(
                  create: (context) => HijriOffsetCubit(),
                ),
                BlocProvider(
                  create: (context) => GetPrayerCalculationMethodCubit(),
                ),
              ],
              child: const PrayerTimeSettingPage(),
            ),
      ),
      GoRoute(
        name: TasbihPage.routeName,
        path: '/tasbih',
        builder:
            (context, state) => BlocProvider(
              create: (context) => TasbihCounterCubit(),
              child: TasbihPage(tasbih: state.extra as List<TasbihModel>),
            ),
      ),
      GoRoute(
        name: QuranListPage.routeName,
        path: '/quran_list_page',
        builder: (context, state) => QuranListPage(),
      ),
      GoRoute(
        name: QuranScreen.routeName,
        path: '/quran',
        builder: (context, state) {
          QuranModel quran = state.extra as QuranModel;
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create:
                    (context) =>
                        DownloadFileBloc()..add(
                          StartDownload(
                            url:
                                'https://drive.google.com/uc?export=download&id=${quran.link}',
                            fileName: quran.fileName,
                            folder: Folder.quran,
                          ),
                        ),
              ),
              BlocProvider(create: (context) => BookMarkCubit()),
            ],
            child: const QuranScreen(),
          );
        },
      ),
      GoRoute(
        name: NotificationPage.routeName,
        path: '/notification_page',
        builder: (context, state) => const NotificationPage(),
      ),
      GoRoute(
        name: CompassPage.routeName,
        path: '/compass',
        builder: (context, state) => const CompassPage(),
      ),
      GoRoute(
        name: SurahListenList.routeName,
        path: '/surah_listen_list',
        builder:
            (context, state) => BlocProvider(
              create: (context) => DownloadFileBloc(),
              child: const SurahListenList(),
            ),
      ),
      GoRoute(
        name: SurahListenPageContent.routeName,
        path: '/surah_listen_page',
        builder: (context, state) {
          if (state.extra == null) {
            return const Scaffold(
              body: Center(child: Text('No audio URL provided')),
            );
          }
          final quranSongModel = state.extra as QuranSongModel;
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => AudioPlayerCubit()..setAudio(quranSongModel),
              ),
              BlocProvider(
                create:
                    (context) =>
                        DownloadFileBloc()..add(
                          CheckFileExist(
                            fileName: quranSongModel.filePath,
                            folder: Folder.quranRecitation,
                          ),
                        ),
              ),
            ],
            child: SurahListenPageContent(quranSongModel: quranSongModel),
          );
        },
      ),

      GoRoute(
        name: StayTunedPage.routeName,
        path: '/stay_tuned_page',
        builder: (context, state) => const StayTunedPage(),
      ),
      GoRoute(
        name: DonateUsScreen.routeName,
        path: '/donate-us',
        builder: (context, state) => const DonateUsScreen(),
      ),
      GoRoute(
        name: AboutUsScreen.routeName,
        path: '/about-us',
        builder: (context, state) => const AboutUsScreen(),
      ),
      GoRoute(
        name: LogsScreen.routeName,
        path: '/logs',
        builder: (context, state) => const LogsScreen(),
      ),
      // GoRoute(
      //   name: 'ramadan_tracker',
      //   path: RamadanTrackerPage.routeName,
      //   builder: (context, state) => const RamadanTrackerPage(),
      // ),
      GoRoute(
        name: AlarmPage.routeName,
        path: '/alarm_page',
        builder: (context, state) => const AlarmPage(),
      ),
      GoRoute(
        name: NotificationReportPage.routeName,
        path: '/notification_report',
        builder: (context, state) => const NotificationReportPage(),
      ),
      GoRoute(
        name: AvoidOvereatingPage.routeName,
        path: '/avoid_overeating',
        builder: (context, state) => const AvoidOvereatingPage(),
      ),
      GoRoute(
        name: CharitySadaqahPage.routeName,
        path: '/charity_sadaqah',
        builder: (context, state) => const CharitySadaqahPage(),
      ),
      GoRoute(
        name: HealthySuhoorPage.routeName,
        path: '/healthy_suhoor',
        builder: (context, state) => const HealthySuhoorPage(),
      ),
      GoRoute(
        name: HydrateOftenScreen.routeName,
        path: '/hydrate_often',
        builder: (context, state) => const HydrateOftenScreen(),
      ),
      GoRoute(
        name: TaraweehPage.routeName,
        path: '/taraweeh',
        builder: (context, state) => const TaraweehPage(),
      ),
      GoRoute(
        name: HistoryTimelinePage.routeName,
        path: '/history_timeline',
        builder: (context, state) {
          final List<HistoryEvent> islamicHistoryEvents = [
            HistoryEvent(
              id: '1',
              title: 'Birth of Prophet Muhammad ﷺ',
              description: 'Prophet Muhammad ﷺ was born in Mecca in the Year of the Elephant.',
              startDate: DateTime(570),
              imageUrl: 'assets/images/birth_prophet.png',
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

          return HistoryTimelinePage(events: islamicHistoryEvents);

        },
      ),

    ],
    // Optional: Custom error page route (404-like)
    errorPageBuilder: (context, state) {
      return MaterialPage<void>(
        key: state.pageKey,
        child: Scaffold(
          appBar: AppBar(title: const Text('Error')),
          body: const Center(child: Text('Page not found!')),
        ),
      );
    },
  );
}
