import 'package:flutter/material.dart';
import 'package:mm_muslim_support/service/local_notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationReportPage extends StatefulWidget {
  const NotificationReportPage({super.key});

  static String routeName = '/notification_report';

  @override
  State<NotificationReportPage> createState() => _NotificationReportPageState();
}

class _NotificationReportPageState extends State<NotificationReportPage> {
  final LocalNotificationService _notificationService = LocalNotificationService();
  List<NotiPayLoad> _notifications = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  Future<void> _loadNotifications() async {
    await _notificationService.initNotification();
    final notifications = await _notificationService.retrievePendingNotificationList();
    setState(() {
      _notifications = notifications;
      _isLoading = false;
    });
  }

  Future<void> _cancelNotification(int id) async {
    await _notificationService.cancelNotificationById(id);
    _loadNotifications(); // refresh list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Notifications'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _notifications.isEmpty
          ? const Center(child: Text('No scheduled notifications'))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notification = _notifications[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              title: Text(notification.name),
              subtitle: Text(
                notification.scheduledTime != null
                    ? 'ID: ${notification.id} • Time: ${notification.scheduledTime!.hour.toString().padLeft(2,'0')}:${notification.scheduledTime!.minute.toString().padLeft(2,'0')}'
                    : 'ID: ${notification.id}',
              ),
              trailing: IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _cancelNotification(notification.id),
              ),
            ),
          );
        },
      ),
    );
  }
}
