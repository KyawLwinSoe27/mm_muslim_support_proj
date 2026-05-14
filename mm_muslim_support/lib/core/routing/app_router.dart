import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mm_muslim_support/common/bloc/download_file_bloc/download_file_bloc.dart';
import 'package:mm_muslim_support/common/cubit/hijri_offset_cubit.dart';
import 'package:mm_muslim_support/core/enums/folder.dart';
import 'package:mm_muslim_support/model/quran_song_model.dart';
import 'package:mm_muslim_support/model/tasbih_model.dart';
import 'package:mm_muslim_support/data/islamic_history_events.dart';
import 'package:mm_muslim_support/module/history/presentation/history_timeline_page.dart';
import 'package:mm_muslim_support/module/history/presentation/islamic_history_page.dart';
import 'package:mm_muslim_support/module/home/cubit/bottom_navigation_bar_cubit.dart';
import 'package:mm_muslim_support/module/home/cubit/get_hijri_date_cubit/get_hijri_date_cubit.dart';
import 'package:mm_muslim_support/module/home/presentation/alarm_page.dart';
import 'package:mm_muslim_support/module/home/presentation/notification_report_page.dart';
import 'package:mm_muslim_support/module/ramadan/presentation/avoid_overeating_page.dart';
import 'package:mm_muslim_support/module/ramadan/presentation/charity_and_sadaqah_page.dart';
import 'package:mm_muslim_support/module/ramadan/presentation/healthy_suhoor_page.dart';
import 'package:mm_muslim_support/module/ramadan/presentation/hydrate_often_page.dart';
import 'package:mm_muslim_support/module/ramadan/presentation/taraweeh_page.dart';
import 'package:mm_muslim_support/module/tasbih/cubit/tasbih_counter_cubit.dart';
import 'package:mm_muslim_support/module/home/presentation/home_page.dart';
import 'package:mm_muslim_support/module/menu/cubit/get_prayer_calculation_method_cubit.dart';
import 'package:mm_muslim_support/module/menu/presentation/about_us_screen.dart';
import 'package:mm_muslim_support/module/menu/presentation/compass_page.dart';
import 'package:mm_muslim_support/module/menu/presentation/donate_us_screen.dart';
import 'package:mm_muslim_support/module/menu/presentation/logs_page.dart';
import 'package:mm_muslim_support/module/menu/presentation/prayer_time_setting_page.dart';
import 'package:mm_muslim_support/module/notification/presentation/notification_page.dart';
import 'package:mm_muslim_support/module/quran/bloc/audio_player_cubit/audio_player_cubit.dart';
import 'package:mm_muslim_support/module/quran/cubit/book_mark_cubit/book_mark_cubit.dart';
import 'package:mm_muslim_support/module/quran/presentation/quran_list_page.dart';
import 'package:mm_muslim_support/module/quran/presentation/quran_screen.dart';
import 'package:mm_muslim_support/module/quran/presentation/surah_listen_list.dart';
import 'package:mm_muslim_support/module/quran/presentation/surah_listen_page.dart';
import 'package:mm_muslim_support/module/home/presentation/prayer_tracker_page.dart';
import 'package:mm_muslim_support/module/quran/presentation/allah_names_page.dart';
import 'package:mm_muslim_support/module/stay_tuned_page.dart';
import 'package:mm_muslim_support/module/tasbih/presentation/tasbih_page.dart';

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
            child: Builder(
              builder: (context) {
                // Set audio if it's different from the currently playing one
                final currentAudio = context.read<AudioPlayerCubit>().currentSong;
                if (currentAudio?.number != quranSongModel.number) {
                  context.read<AudioPlayerCubit>().setAudio(quranSongModel);
                }
                return SurahListenPageContent(quranSongModel: quranSongModel);
              }
            ),
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
          return HistoryTimelinePage(events: islamicHistoryEvents);
        },
      ),
      GoRoute(
        name: AllahNamesPage.routeName,
        path: '/allah_names',
        builder: (context, state) => const AllahNamesPage(),
      ),
      GoRoute(
        name: PrayerTrackerPage.routeName,
        path: '/prayer_tracker',
        builder: (context, state) => const PrayerTrackerPage(),
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
