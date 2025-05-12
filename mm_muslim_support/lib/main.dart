import 'package:audio_service/audio_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mm_muslim_support/core/routing/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mm_muslim_support/core/themes/theme.dart';
import 'package:mm_muslim_support/firebase_options.dart';
import 'package:mm_muslim_support/logic/theme_cubit.dart';
import 'package:mm_muslim_support/service/audio_handler.dart';
import 'package:mm_muslim_support/service/local_notification_service.dart';
import 'package:mm_muslim_support/service/location_service.dart';
import 'package:mm_muslim_support/service/permission_service.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
late final AudioPlayerHandler audioHandler;


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await LocalNotificationService.initializeNotifications();
  // tz.initializeTimeZones();
  final sharedPrefs = SharedPreferenceService();
  await sharedPrefs.init();
  LocalNotificationService().initNotification();
  await PermissionService.requestNotificationPermission();

  bool wasInBackground =  SharedPreferenceService.getAppLifeCycle() ?? false;
  if(!wasInBackground) {
    await LocationService.getCurrentLocation();
    await SharedPreferenceService.setAppLifeCycle(true);
  }

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Subscribe to topic AFTER Firebase is initialized
  await FirebaseMessaging.instance.subscribeToTopic('all_devices');

  audioHandler = await AudioService.init(
    builder: () => AudioPlayerHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.audio',
      androidNotificationChannelName: 'Audio Playback',
      androidNotificationOngoing: true,
    ),
  );

  runApp(BlocProvider(create: (context) => ThemeCubit(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final MaterialTheme customTheme = MaterialTheme(Typography.material2021().black);

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp.router(
          title: 'Minara',
          debugShowCheckedModeBanner: false,
          theme: customTheme.light(),
          darkTheme: customTheme.dark(),
          highContrastTheme: customTheme.lightHighContrast(),
          highContrastDarkTheme: customTheme.darkHighContrast(),
          themeMode: themeMode,
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
