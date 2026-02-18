import 'dart:ui';
import 'package:flutter/material.dart';

class TimeCardsRow extends StatelessWidget {
  final String suhoorTime;
  final String nextPrayerName;
  final String nextPrayerTime;
  final String iftarTime;

  const TimeCardsRow({
    super.key,
    required this.suhoorTime,
    required this.nextPrayerName,
    required this.nextPrayerTime,
    required this.iftarTime,
  });

  Widget _glassCard(BuildContext context, String title, String time, {Color? accent}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (accent ?? colorScheme.surface).withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: (accent ?? colorScheme.primary).withOpacity(0.2)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: accent ?? colorScheme.primary)),
                  const SizedBox(height: 8),
                  Text(time, style: Theme.of(context).textTheme.titleMedium),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        _glassCard(context, 'Suhoor', suhoorTime, accent: colorScheme.primary),
        _glassCard(context, nextPrayerName, nextPrayerTime, accent: colorScheme.secondary),
        _glassCard(context, 'Iftar', iftarTime, accent: colorScheme.tertiary),
      ],
    );
  }
}
