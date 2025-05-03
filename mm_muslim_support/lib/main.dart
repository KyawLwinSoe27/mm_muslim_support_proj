import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mm_muslim_support/core/routing/app_router.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mm_muslim_support/core/themes/theme.dart';
import 'package:mm_muslim_support/firebase_options.dart';
import 'package:mm_muslim_support/logic/theme_cubit.dart';
import 'package:mm_muslim_support/service/local_notification_service.dart';
import 'package:mm_muslim_support/service/permission_service.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await LocalNotificationService.initializeNotifications();
  // tz.initializeTimeZones();
  LocalNotificationService().initNotification();
  await PermissionService.requestNotificationPermission();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(BlocProvider(create: (context) => ThemeCubit(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    MaterialTheme customTheme = MaterialTheme(Typography
        .material2021()
        .black);

    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        return MaterialApp.router(
          title: 'Myanmar Muslim Support',
          debugShowCheckedModeBanner: false,
          theme: customTheme.light(),
          darkTheme: customTheme.dark(),
          highContrastTheme: customTheme.lightHighContrast(),
          highContrastDarkTheme: customTheme.darkHighContrast(),
          themeMode: themeMode, // ← this is correct
          routerConfig: AppRouter.router,
        );
      },
    );
  }
}
