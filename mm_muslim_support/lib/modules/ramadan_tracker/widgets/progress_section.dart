import 'package:flutter/material.dart';

class ProgressSection extends StatelessWidget {
  final double progress;
  final int daysLeft;
  final int totalDays;

  const ProgressSection({
    super.key,
    required this.progress,
    required this.daysLeft,
    required this.totalDays,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Column(
      children: [
        SizedBox(
          height: 120,
          width: 120,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircularProgressIndicator(
                value: progress,
                strokeWidth: 10,
                backgroundColor: colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation(colorScheme.primary),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('$daysLeft', style: Theme.of(context).textTheme.displaySmall?.copyWith(color: colorScheme.primary)),
                  Text('Days Left', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text('of $totalDays days', style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
