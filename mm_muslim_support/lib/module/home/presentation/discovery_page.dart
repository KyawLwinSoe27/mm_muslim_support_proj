import 'package:flutter/material.dart';
import 'package:mm_muslim_support/service/local_notification_service.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class DiscoveryPage extends StatefulWidget {
  const DiscoveryPage({super.key});

  @override
  State<DiscoveryPage> createState() => _DiscoveryPageState();
}

class _DiscoveryPageState extends State<DiscoveryPage> {
  List<NotiPayLoad> notiPayload = [];

  void _loadNotifications() async {
    final List<NotiPayLoad> pendingNotis =
        await LocalNotificationService().retrievePendingNotificationList();
    setState(() {
      notiPayload = pendingNotis;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Discovery',
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colorScheme.onSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: _loadNotifications,
            child: const Text('Get Scheduled Notifications'),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: notiPayload.length,
              itemBuilder: (context, index) {
                final noti = notiPayload[index];
                return ListTile(
                  title: Text('ID: ${noti.id}'),
                  subtitle: Text(noti.name),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
