import 'package:flutter/material.dart';

class BottomNavPlaceholder extends StatelessWidget {
  const BottomNavPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Bottom Navigation (Coming Soon)',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: colorScheme.outline),
        ),
      ),
    );
  }
}
