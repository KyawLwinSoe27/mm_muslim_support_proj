import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mm_muslim_support/core/routing/app_router.dart';
import 'package:mm_muslim_support/core/routing/context_ext.dart';
import 'package:mm_muslim_support/logic/theme_cubit.dart';
import 'package:mm_muslim_support/module/menu/presentation/setting_page.dart';

class DrawerWidget extends StatelessWidget {
  const DrawerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          Container(
            height: 120,
            decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary),
            child: Padding(
              padding: const EdgeInsets.only(top: 80, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('MM Support', style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.notifications, color: Theme.of(context).colorScheme.onPrimary),
                        onPressed: () {
                          // Handle notification button press
                        },
                      ),
                      IconButton(icon: Icon(Icons.brightness_6, color: Theme.of(context).colorScheme.onPrimary), onPressed: () => context.read<ThemeCubit>().toggleTheme()),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              context.pop();
              context.navigateWithPushNamed(SettingPage.routeName);
            },
          ),
          ListTile(
            title: const Text('Item 2'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }
}