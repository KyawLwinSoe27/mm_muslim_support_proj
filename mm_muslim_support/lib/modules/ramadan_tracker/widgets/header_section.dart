import 'package:flutter/material.dart';

class HeaderSection extends StatelessWidget {
  final String title;
  final String location;
  final String dayIndicator;
  final VoidCallback? onBack;
  final VoidCallback? onShare;

  const HeaderSection({
    super.key,
    required this.title,
    required this.location,
    required this.dayIndicator,
    this.onBack,
    this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: onBack, // TODO: Implement navigation
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.location_on, size: 16, color: colorScheme.primary),
                    const SizedBox(width: 4),
                    Text(location, style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(dayIndicator, style: Theme.of(context).textTheme.labelSmall),
                    ),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: onShare, // TODO: Implement share
          ),
        ],
      ),
    );
  }
}
