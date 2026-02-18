import 'package:flutter/material.dart';
import 'package:mm_muslim_support/service/local_notification_service.dart';
import 'package:mm_muslim_support/utility/extensions.dart';
import 'package:timezone/timezone.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  static const String routeName = '/notification_page';

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  DateTime? selectedDateTime;

  Future<void> _pickDateTime() async {
    // Show date picker
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null && mounted) {
      // Show time picker
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() async {
          selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
          TZDateTime scheduledDate = TZDateTime.from(selectedDateTime!, local);
          await LocalNotificationService().scheduleNotification(
            id: selectedDateTime?.millisecond ?? 0,
            title: 'Alarm',
            body:
                'This is schedule test alarm ${selectedDateTime?.hour}:${selectedDateTime?.minute}',
            scheduledDate: scheduledDate,
          );
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification Page',
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colorScheme.onSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickDateTime,
              child: const Text('Set the alarm'),
            ),
            if (selectedDateTime != null)
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text(
                  'Selected Date & Time: ${selectedDateTime.toString()}',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
