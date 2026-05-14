import 'package:flutter/material.dart';
import 'package:mm_muslim_support/core/routing/context_ext.dart';
import 'package:mm_muslim_support/module/home/presentation/alarm_page.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class HealthySuhoorPage extends StatelessWidget {
  const HealthySuhoorPage({super.key});

  static const String routeName = '/healthy_suhoor';

  static const List<Map<String, String>> tips = [
    {'title': 'Hydrate Well', 'description': 'Drink plenty of water to stay hydrated throughout the day.'},
    {'title': 'Include Protein', 'description': 'Eggs, yogurt, and legumes keep you full longer.'},
    {'title': 'Eat Complex Carbs', 'description': 'Oats, whole grains, and fruits provide sustained energy.'},
    {'title': 'Fruits & Vegetables', 'description': 'Vitamins and fiber help digestion and energy levels.'},
    {'title': 'Avoid Fried Foods', 'description': 'Heavy foods can cause lethargy during fasting.'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Healthy Suhoor', style: context.textTheme.titleLarge?.copyWith(color: context.colorScheme.onSecondary, fontWeight: FontWeight.bold)),
        centerTitle: true,
        backgroundColor: context.colorScheme.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.green.shade400, Colors.green.shade800], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.breakfast_dining, size: 60, color: Colors.white),
                  const SizedBox(height: 12),
                  Text('Tips for a Healthy Suhoor', style: context.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.white), textAlign: TextAlign.center),
                  const SizedBox(height: 8),
                  Text(
                    'Eating the right foods before Fajr helps you maintain energy and stay hydrated during the fast.',
                    style: context.textTheme.bodyMedium?.copyWith(color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ...tips.map(
              (tip) => Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                elevation: 4,
                child: ListTile(
                  leading: CircleAvatar(backgroundColor: context.colorScheme.primary, child: const Icon(Icons.check, color: Colors.white)),
                  title: Text(tip['title']!, style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  subtitle: Text(tip['description']!, style: context.textTheme.bodyMedium),
                ),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.notifications_active),
              label: const Text('Set Suhoor Reminder'),
              style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              onPressed: () => context.navigateWithPushNamed(AlarmPage.routeName),
            ),
          ],
        ),
      ),
    );
  }
}
