import 'package:flutter/material.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class AvoidOvereatingPage extends StatelessWidget {
  const AvoidOvereatingPage({super.key});

  static const String routeName = '/avoid_overeating';

  @override
  Widget build(BuildContext context) {
    final List<String> tips = [
      'Start with a glass of water before eating.',
      'Break your fast with dates or light snacks.',
      'Eat slowly and chew properly.',
      'Include vegetables and fruits in your meal.',
      'Avoid fried and heavy foods.',
      'Listen to your body and stop when full.',
      'Have smaller portions for suhoor and iftar.',
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Avoid Overeating'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.no_food,
              size: 80,
              color: context.colorScheme.primary,
            ),
            const SizedBox(height: 20),
            Text(
              'Healthy Eating During Ramadan',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.separated(
                itemCount: tips.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  return Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: context.colorScheme.secondary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: context.colorScheme.primary.withValues(alpha: 0.5),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 14,
                          backgroundColor: context.colorScheme.primary,
                          child: Text(
                            '${index + 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            tips[index],
                            style: context.textTheme.bodyMedium,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
