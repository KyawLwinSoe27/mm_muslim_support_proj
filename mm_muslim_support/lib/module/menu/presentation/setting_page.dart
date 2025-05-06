import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/module/menu/cubit/change_language_cubit.dart';
import 'package:mm_muslim_support/service/location_service.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';
import 'package:mm_muslim_support/utility/extensions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  static const String routeName = 'settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Settings',
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colorScheme.onSecondary,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(right: 10),
        children: [
          Row(
            children: [
              Expanded(
                child: ListTile(
                  leading: Icon(Icons.language),
                  title: Text('Language'),
                  subtitle: Text('Select your preferred language'),
                  onTap: () {
                    // Navigate to language selection screen
                  },
                ),
              ),
              BlocProvider(
                create: (context) => ChangeLanguageCubit(),
                child: BlocBuilder<ChangeLanguageCubit, bool>(
                  builder: (context, state) {
                    return Row(
                      children: [
                        Text('Eng'),
                        Switch(value: state, onChanged: (value) => context.read<ChangeLanguageCubit>()..toggleLanguage()),
                        Text('MM'),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
          ListTile(
            leading: Icon(Icons.location_on),
            title: Text('Update Location'),
            subtitle: Text('Set or update your current location'),
            onTap: () async{
              await SharedPreferenceService.removePlaceMarksName();
              await LocationService.getCurrentLocation();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Successfully updated location'),
                  backgroundColor: Colors.red,
                  duration: const Duration(minutes: 5),
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(Icons.access_time),
            title: Text('Prayer Time Settings'),
            subtitle: Text('Choose method, juristic, and format'),
            onTap: () {
              // Navigate to prayer time settings
            },
          ),
          ListTile(
            leading: Icon(Icons.explore),
            title: Text('Qibla Settings'),
            subtitle: Text('Calibrate compass and settings'),
            onTap: () {
              // Navigate to Qibla settings
            },
          ),
          ListTile(
            leading: Icon(Icons.book),
            title: Text('Quran & Hadith Preferences'),
            subtitle: Text('Set default translation or Hadith source'),
            onTap: () {
              // Navigate to content preferences
            },
          ),
          ListTile(
            leading: Icon(Icons.backup),
            title: Text('Backup & Restore'),
            subtitle: Text('Manage your app settings'),
            onTap: () {
              // Navigate to backup/restore
            },
          ),
          ListTile(
            leading: Icon(Icons.info),
            title: Text('About'),
            subtitle: Text('App info, developer, licenses'),
            onTap: () {
              // Navigate to about page
            },
          ),
          ListTile(
            leading: Icon(Icons.star),
            title: Text('Rate Us'),
            onTap: () {
              // Open app store link
            },
          ),
          ListTile(
            leading: Icon(Icons.share),
            title: Text('Share App'),
            onTap: () {
              // Share app link
            },
          ),
        ],
      ),
    );
  }
}