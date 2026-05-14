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
import 'package:mm_muslim_support/module/home/presentation/prayer_tracker_page.dart';
import 'package:mm_muslim_support/module/notification/presentation/notification_page.dart';
import 'package:mm_muslim_support/module/quran/presentation/allah_names_page.dart';
import 'package:mm_muslim_support/module/quran/presentation/quran_list_page.dart';
import 'package:mm_muslim_support/module/quran/presentation/surah_listen_list.dart';
import 'package:mm_muslim_support/module/stay_tuned_page.dart';
import 'package:mm_muslim_support/service/permission_service.dart';
import 'package:mm_muslim_support/utility/constants.dart';
import 'package:mm_muslim_support/utility/dialog_utils.dart';
import 'package:mm_muslim_support/widget/rate_us_dialog.dart';
import 'package:mm_muslim_support/widget/share_app_helper.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [theme.colorScheme.primary, theme.colorScheme.primary.withValues(alpha: 0.85)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 16, left: 20, right: 12, bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 24,
                      backgroundColor: Colors.white.withValues(alpha: 0.2),
                      child: Text('M', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.notifications_outlined, color: Colors.white),
                      onPressed: () => context.navigateWithPushNamed(NotificationPage.routeName),
                    ),
                    IconButton(
                      icon: const Icon(Icons.brightness_6, color: Colors.white),
                      onPressed: () => context.read<ThemeCubit>().toggleTheme(),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(AppConstants.appName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                _DrawerSection(title: 'GENERAL'),
                _DrawerTile(icon: Icons.location_on_rounded, title: 'Update Location', onTap: () => _onUpdateLocation(context)),
                _DrawerTile(icon: Icons.menu_book_rounded, title: 'Quran', onTap: () => context.navigateWithPushNamed(QuranListPage.routeName)),
                _DrawerTile(icon: Icons.multitrack_audio_rounded, title: 'Quran Audio', onTap: () => context.navigateWithPushNamed(SurahListenList.routeName)),
                _DrawerTile(icon: Icons.auto_awesome_rounded, title: '99 Names of Allah', onTap: () => context.navigateWithPushNamed(AllahNamesPage.routeName)),
                _DrawerTile(icon: Icons.checklist_rounded, title: 'Prayer Tracker', onTap: () => context.navigateWithPushNamed(PrayerTrackerPage.routeName)),
                _DrawerTile(icon: Icons.settings_rounded, title: 'Prayer Settings', onTap: () => context.navigateWithPushNamed(PrayerTimeSettingPage.routeName)),
                _DrawerTile(icon: Icons.explore_rounded, title: 'Qibla Compass', onTap: () => context.navigateWithPushNamed(CompassPage.routeName)),
                const Divider(indent: 16, endIndent: 16),
                _DrawerSection(title: 'MORE'),
                _DrawerTile(icon: Icons.book_online_rounded, title: 'Hadith', onTap: () => context.navigateWithPushNamed(StayTunedPage.routeName)),
                _DrawerTile(icon: Icons.balance_rounded, title: 'Fatwa', onTap: () => context.navigateWithPushNamed(StayTunedPage.routeName)),
                _DrawerTile(icon: Icons.backup_rounded, title: 'Backup & Restore', onTap: () => context.navigateWithPushNamed(StayTunedPage.routeName)),
                const Divider(indent: 16, endIndent: 16),
                _DrawerSection(title: 'ABOUT'),
                _DrawerTile(icon: Icons.volunteer_activism_rounded, title: 'Donate', onTap: () => context.navigateWithPushNamed(DonateUsScreen.routeName)),
                _DrawerTile(icon: Icons.info_rounded, title: 'About', onTap: () => context.navigateWithPushNamed(AboutUsScreen.routeName)),
                _DrawerTile(icon: Icons.file_copy_rounded, title: 'Logs', onTap: () => context.navigateWithPushNamed(LogsScreen.routeName)),
                _DrawerTile(icon: Icons.star_rounded, title: 'Rate Us', onTap: () => RateUsDialog.show(context)),
                _DrawerTile(icon: Icons.share_rounded, title: 'Share App', onTap: () => AppShareHelper.shareApp()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onUpdateLocation(BuildContext context) async {
    final cubit = context.read<GetLocationCubit>();
    if (await PermissionService.googleServiceAvailable()) {
      cubit.getCurrentLocation();
    } else if (context.mounted) {
      DialogUtils.showErrorDialog(context, 'Google Service not available. Location cannot be updated.');
    }
  }
}

class _DrawerSection extends StatelessWidget {
  final String title;
  const _DrawerSection({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Text(title, style: theme.textTheme.labelSmall?.copyWith(
        color: theme.colorScheme.primary,
        fontWeight: FontWeight.w600,
        letterSpacing: 0.5,
      )),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  const _DrawerTile({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListTile(
      leading: Icon(icon, size: 22, color: theme.colorScheme.onSurfaceVariant),
      title: Text(title, style: theme.textTheme.bodyMedium),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
      dense: true,
    );
  }
}
