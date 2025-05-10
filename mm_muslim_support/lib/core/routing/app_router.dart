import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mm_muslim_support/common/bloc/download_file_bloc/download_file_bloc.dart';
import 'package:mm_muslim_support/core/enums/folder.dart';
import 'package:mm_muslim_support/model/quran_song_model.dart';
import 'package:mm_muslim_support/model/tasbih_model.dart';
import 'package:mm_muslim_support/module/history/presentations/islamic_history_page.dart';
import 'package:mm_muslim_support/module/home/cubit/bottom_navigation_bar_cubit.dart';
import 'package:mm_muslim_support/module/home/cubit/tasbih_counter_cubit.dart';
import 'package:mm_muslim_support/module/home/presentation/home_page.dart';
import 'package:mm_muslim_support/module/menu/cubit/get_prayer_calculation_method_cubit.dart';
import 'package:mm_muslim_support/module/menu/presentation/compass_page.dart';
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
      GoRoute(name: HomePage.routeName, path: '/', builder: (context, state) => BlocProvider(create: (context) => BottomNavigationBarCubit(), child: const HomePage())),
      GoRoute(name: IslamicHistoryPage.routeName, path: '/history', builder: (context, state) => const IslamicHistoryPage()),
      // Login Route
      GoRoute(
        name: PrayerTimeSettingPage.routeName,
        path: '/prayerSettingPage',
        builder: (context, state) => BlocProvider(create: (context) => GetPrayerCalculationMethodCubit(), child: const PrayerTimeSettingPage()),
      ),
      GoRoute(
        name: TasbihPage.routeName,
        path: '/tasbih',
        builder: (context, state) => BlocProvider(create: (context) => TasbihCounterCubit(), child: TasbihPage(tasbih: state.extra as List<TasbihModel>)),
      ),
      GoRoute(name: QuranListPage.routeName, path: '/quran_list_page', builder: (context, state) => QuranListPage()),
      GoRoute(
        name: QuranScreen.routeName,
        path: '/quran',
        builder: (context, state) {
          QuranModel quran = state.extra as QuranModel;
          return MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (context) =>
                DownloadFileBloc()
                  ..add(StartDownload(url: 'https://drive.google.com/uc?export=download&id=${quran.link}', fileName: quran.fileName, folder: Folder.quran)),
              ),
              BlocProvider(create: (context) => BookMarkCubit()),
            ],
            child: const QuranScreen(),
          );
        },
      ),
      GoRoute(name: NotificationPage.routeName, path: '/notification_page', builder: (context, state) => const NotificationPage()),
      GoRoute(name: CompassPage.routeName, path: '/compass', builder: (context, state) => const CompassPage()),
      GoRoute(name: SurahListenList.routeName, path: '/surah_listen_list', builder: (context, state) => BlocProvider(create: (context) => DownloadFileBloc(), child: const SurahListenList())),
      GoRoute(name: SurahListenPageContent.routeName, path: '/surah_listen_page', builder: (context, state) {
        if (state.extra == null) {
          return const Scaffold(
            body: Center(
              child: Text('No audio URL provided'),
            ),
          );
        }
        final quranSongModel = state.extra as QuranSongModel;
        return BlocProvider(
          create: (_) => AudioPlayerCubit()..setAudio(quranSongModel),
          child: SurahListenPageContent(quranSongModel:  quranSongModel),
        );
      }),

      GoRoute(name: StayTunedPage.routeName, path: '/stay_tuned_page', builder: (context, state) => const StayTunedPage()),
    ],
    // Optional: Custom error page route (404-like)
    errorPageBuilder: (context, state) {
      return MaterialPage<void>(key: state.pageKey, child: Scaffold(appBar: AppBar(title: const Text('Error')), body: const Center(child: Text('Page not found!'))));
    },
  );
}
