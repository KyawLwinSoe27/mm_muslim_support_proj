import 'package:flutter/material.dart';
import 'package:mm_muslim_support/model/historical_event.dart';
import 'package:mm_muslim_support/widget/islamic_history_widget.dart';

class IslamicHistoryPage extends StatelessWidget {
  const IslamicHistoryPage({super.key});

  static const islamicHistory = 'islamicHistory';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Islamic History'),
      ),
      body: ListView.builder(
        itemCount: historicalEvents.length, // Replace with your data length
        itemBuilder: (context, index) {
          return IslamicHistoryWidget(event: historicalEvents[index]);
        },
      ),
    );
  }
}
