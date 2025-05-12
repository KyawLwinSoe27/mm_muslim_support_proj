import 'package:flutter/material.dart';
import 'package:mm_muslim_support/model/historical_event.dart';
import 'package:mm_muslim_support/utility/extensions.dart';
import 'package:mm_muslim_support/widget/islamic_history_widget.dart';

class IslamicHistoryPage extends StatelessWidget {
  const IslamicHistoryPage({super.key});

  static const routeName = 'islamicHistory';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Islamic History', style: context.textTheme.titleLarge?.copyWith(color: context.colorScheme.onSecondary, fontWeight: FontWeight.w500))),
      body: ListView.builder(
        itemCount: historicalEvents.length, // Replace with your data length
        itemBuilder: (context, index) {
          return IslamicHistoryWidget(event: historicalEvents[index]);
        },
      ),
    );
  }
}
