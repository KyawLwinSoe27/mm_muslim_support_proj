import 'package:flutter/material.dart';
import 'package:mm_muslim_support/models/ramadan_day_model.dart';

class MonthlyScheduleList extends StatelessWidget {
  final List<RamadanDayModel> schedule;
  final int currentDay;

  const MonthlyScheduleList({
    super.key,
    required this.schedule,
    required this.currentDay,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: schedule.length,
      separatorBuilder: (_, __) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final day = schedule[index];
        final isToday = day.isToday;
        final isCompleted = day.isCompleted;
        return Container(
          decoration: BoxDecoration(
            color: isToday
                ? colorScheme.primary.withOpacity(0.1)
                : isCompleted
                    ? colorScheme.surfaceVariant.withOpacity(0.2)
                    : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: isToday ? colorScheme.primary : colorScheme.surfaceVariant,
              child: Text('${day.day}', style: TextStyle(color: isToday ? colorScheme.onPrimary : colorScheme.onSurface)),
            ),
            title: Text(
              '${day.date.day}/${day.date.month}/${day.date.year}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            subtitle: Text('Fajr: ${_formatTime(day.prayerTimes.values.first)} | Maghrib: ${_formatTime(day.prayerTimes.values.elementAt(3))}'),
            trailing: isCompleted
                ? Icon(Icons.check_circle, color: colorScheme.primary)
                : Icon(Icons.radio_button_unchecked, color: colorScheme.outline),
          ),
        );
      },
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}
