import 'package:flutter/material.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class HydrateOftenScreen extends StatelessWidget {
  const HydrateOftenScreen({super.key});

  static const String routeName = '/hydrate_often';

  static const List<Map<String, String>> tips =  [
    {
      'title': 'Drink Plenty of Water',
      'description': 'Consume water during Suhoor and Iftar to stay hydrated.'
    },
    {
      'title': 'Avoid Sugary Drinks',
      'description': 'Sodas and sweet juices can cause dehydration faster.'
    },
    {
      'title': 'Eat Water-rich Foods',
      'description': 'Fruits like watermelon, cucumber, and oranges help hydration.'
    },
    {
      'title': 'Space Out Water Intake',
      'description': 'Drink regularly between Iftar and Suhoor instead of all at once.'
    },
    {
      'title': 'Limit Caffeine',
      'description': 'Coffee and tea can have a diuretic effect, drink in moderation.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hydrate Often',
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colorScheme.onSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue.shade400, Colors.blue.shade800],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.local_drink, size: 60, color: Colors.white),
                  const SizedBox(height: 12),
                  Text(
                    'Stay Hydrated During Ramadan',
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Proper hydration helps maintain energy, focus, and overall health while fasting.',
                    style: context.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Tips
            ...tips.map(
                  (tip) => Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 4,
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: context.colorScheme.primary,
                    child: const Icon(Icons.water_drop, color: Colors.white),
                  ),
                  title: Text(
                    tip['title']!,
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    tip['description']!,
                    style: context.textTheme.bodyMedium,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            // Reminder Button
            ElevatedButton.icon(
              icon: const Icon(Icons.notifications_active),
              label: const Text('Set Hydration Reminder'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: () {
                // TODO: Implement notification for hydration reminders
              },
            ),
          ],
        ),
      ),
    );
  }
}
