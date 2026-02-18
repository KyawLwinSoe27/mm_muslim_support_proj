import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/core/routing/context_ext.dart';
import 'package:mm_muslim_support/logic/theme_cubit.dart';
import 'package:mm_muslim_support/module/menu/cubit/get_location_cubit/get_location_cubit.dart';
import 'package:mm_muslim_support/module/menu/presentation/about_us_screen.dart';
import 'package:mm_muslim_support/module/menu/presentation/compass_page.dart';
import 'package:mm_muslim_support/module/menu/presentation/donate_us_screen.dart';
import 'package:mm_muslim_support/module/menu/presentation/logs_page.dart';
import 'package:mm_muslim_support/module/menu/presentation/prayer_time_setting_page.dart';
import 'package:mm_muslim_support/module/notification/presentations/notification_page.dart';
import 'package:mm_muslim_support/module/quran/presentations/quran_list_page.dart';
import 'package:mm_muslim_support/module/quran/presentations/surah_listen_list.dart';
import 'package:mm_muslim_support/module/stay_tuned_page.dart';
import 'package:mm_muslim_support/service/permission_service.dart';
import 'package:mm_muslim_support/utility/constants.dart';
import 'package:mm_muslim_support/utility/dialog_utils.dart';
import 'package:mm_muslim_support/utility/extensions.dart';
import 'package:mm_muslim_support/widget/rate_us_dialog.dart';
import 'package:mm_muslim_support/widget/share_app_helper.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.secondary,
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 80, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppConstants.appName,
                    style: context.textTheme.titleLarge?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.notifications,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        onPressed: () {
                          context.navigateWithPushNamed(
                            NotificationPage.routeName,
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.brightness_6,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                        onPressed:
                            () => context.read<ThemeCubit>().toggleTheme(),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView(
              // Important: Remove any padding from the ListView.
              padding: EdgeInsets.zero,
              children: [
                // Row(
                //   children: [
                //     Expanded(
                //       child: ListTile(
                //         leading: const Icon(Icons.language_rounded),
                //         title: const Text('Language'),
                //         onTap: () {
                //           // Navigate to language selection screen
                //         },
                //       ),
                //     ),
                //     BlocProvider(
                //       create: (context) => ChangeLanguageCubit(),
                //       child: BlocBuilder<ChangeLanguageCubit, bool>(
                //         builder: (context, state) {
                //           return Row(
                //             children: [
                //               const Text('Eng'),
                //               Switch(value: state, onChanged: (value) =>
                //               context.read<ChangeLanguageCubit>()
                //                 ..toggleLanguage()),
                //               const Text('MM'),
                //               const SizedBox(width: 10,)
                //             ],
                //           );
                //         },
                //       ),
                //     )
                //   ],
                // ),
                BlocListener<GetLocationCubit, GetLocationState>(
                  listener: (context, state) {
                    if (state is GetLocationLoading) {
                      DialogUtils.loadingDialog(context);
                    } else if (state is GetLocationLoaded) {
                      context.back();
                      DialogUtils.showSuccessDialog(context, state.location);
                    } else if (state is GetLocationError) {
                      context.back();
                      DialogUtils.showErrorDialog(
                        context,
                        'Failed to update location',
                      );
                    }
                  },
                  child: ListTile(
                    leading: const Icon(Icons.location_on_rounded),
                    title: const Text('Update Location'),
                    onTap: () async {
                      GetLocationCubit getLocationCubit =
                          context.read<GetLocationCubit>();
                      if (await PermissionService.googleServiceAvailable()) {
                        getLocationCubit.getCurrentLocation();
                      } else {
                        if (context.mounted) {
                          DialogUtils.showErrorDialog(
                            context,
                            'Your phone doesn\'t support Google Service, your location cannot be updated. In Minara App Version 1.1.0, you can update your location.',
                          );
                        }
                      }
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.settings_rounded),
                  title: const Text('Prayer Time Settings'),
                  onTap:
                      () => context.navigateWithPushNamed(
                        PrayerTimeSettingPage.routeName,
                      ),
                ),
                ListTile(
                  leading: const Icon(Icons.menu_book_rounded),
                  title: const Text('Quran'),
                  onTap:
                      () => context.navigateWithPushNamed(
                        QuranListPage.routeName,
                      ),
                ),
                ListTile(
                  leading: const Icon(Icons.multitrack_audio_rounded),
                  title: const Text('Quran Audio'),
                  onTap:
                      () => context.navigateWithPushNamed(
                        SurahListenList.routeName,
                      ),
                ),
                ListTile(
                  leading: const Icon(Icons.book_online_rounded),
                  title: const Text('Hadith'),
                  onTap:
                      () => context.navigateWithPushNamed(
                        StayTunedPage.routeName,
                      ),
                ),
                ListTile(
                  leading: const Icon(Icons.balance_rounded),
                  title: const Text('Fatwa'),
                  onTap:
                      () => context.navigateWithPushNamed(
                        StayTunedPage.routeName,
                      ),
                ),
                ListTile(
                  leading: const Icon(Icons.explore_rounded),
                  title: const Text('Qibla'),
                  onTap:
                      () =>
                          context.navigateWithPushNamed(CompassPage.routeName),
                ),
                ListTile(
                  leading: const Icon(Icons.backup_rounded),
                  title: const Text('Backup & Restore'),
                  onTap:
                      () => context.navigateWithPushNamed(
                        StayTunedPage.routeName,
                      ),
                ),
                ListTile(
                  leading: const Icon(Icons.info_rounded),
                  title: const Text('About'),
                  onTap:
                      () => context.navigateWithPushNamed(
                        AboutUsScreen.routeName,
                      ),
                ),
                ListTile(
                  leading: const Icon(Icons.file_copy_rounded),
                  title: const Text('Logs'),
                  onTap:
                      () => context.navigateWithPushNamed(LogsScreen.routeName),
                ),
                ListTile(
                  leading: const Icon(Icons.volunteer_activism_rounded),
                  title: const Text('Donate Us'),
                  onTap:
                      () => context.navigateWithPushNamed(
                        DonateUsScreen.routeName,
                      ),
                ),
                ListTile(
                  leading: const Icon(Icons.star_rounded),
                  title: const Text('Rate Us'),
                  onTap: () => RateUsDialog.show(context),
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share App'),
                  onTap: () => AppShareHelper.shareApp(),
                ),
                // ListTile(
                //   leading: const Icon(Icons.nightlight_round),
                //   title: const Text('Ramadan Tracker'),
                //   onTap: () {
                //     Navigator.of(context).pop(); // Close drawer
                //     GoRouter.of(context).go('/ramadan_tracker');
                //   },
                // ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
