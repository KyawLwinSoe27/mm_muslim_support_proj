import 'package:flutter/material.dart';
import 'package:mm_muslim_support/model/historical_event.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class IslamicHistoryWidget extends StatelessWidget {
  const IslamicHistoryWidget({
    super.key, required this.event,
  });

  final HistoricalEvent event;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(event.imageUrl),
            Text(event.title, style: context.textTheme.titleMedium,),
            const SizedBox(height: 10),
            Text(event.description, style: context.textTheme.labelSmall,),
            const SizedBox(height: 10),
            Text(event.date, style: context.textTheme.labelSmall?.copyWith(color: context.colorScheme.primary),),
          ],
        ),
      ),
    );
  }
}