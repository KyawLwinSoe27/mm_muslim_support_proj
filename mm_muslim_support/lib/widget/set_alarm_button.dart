import 'package:flutter/material.dart';
import 'package:mm_muslim_support/core/routing/context_ext.dart';
import 'package:mm_muslim_support/module/home/presentation/alarm_page.dart';

class SetAlarmButton extends StatelessWidget {
  const SetAlarmButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      icon: const Icon(Icons.alarm),
      label: const Text(
        'Set Prayer Alarm',
        style: TextStyle(fontSize: 16),
      ),
      onPressed: () {

      },
    );
  }
}
