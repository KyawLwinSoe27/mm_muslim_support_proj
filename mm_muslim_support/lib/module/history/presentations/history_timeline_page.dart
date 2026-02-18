import 'package:flutter/material.dart';

class HistoryEvent {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime? endDate; // Optional for events that span time
  final String? imageUrl;  // Optional illustration or reference image
  final String? reference; // Optional source

  HistoryEvent({
    required this.title,
    required this.description,
    required this.startDate,
    this.endDate,
    required this.id,
    this.reference,
    this.imageUrl,
  });
}

class HistoryTimelinePage extends StatelessWidget {
  static const String routeName = '/history_timeline';

  final List<HistoryEvent> events;

  const HistoryTimelinePage({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: events.length,
        itemBuilder: (context, index) {
          final event = events[index];
          final isLast = index == events.length - 1;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Timeline line & dot
              Column(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary,
                      shape: BoxShape.circle,
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 100,
                      color: theme.colorScheme.primary.withOpacity(0.4),
                    ),
                ],
              ),
              const SizedBox(width: 16),
              // Event Card
              Expanded(
                child: Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${event.startDate.year}${event.endDate != null ? ' - ${event.endDate!.year}' : ''}',
                          style: theme.textTheme.labelMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          event.title,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          event.description,
                          style: theme.textTheme.bodyMedium,
                        ),
                        if (event.imageUrl != null) ...[
                          const SizedBox(height: 12),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              event.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ],
                        if (event.reference != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Source: ${event.reference}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: theme.colorScheme.secondary,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
