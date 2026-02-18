import 'package:flutter/material.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class CharitySadaqahPage extends StatelessWidget {
  const CharitySadaqahPage({super.key});

  static const String routeName = '/charity_sadaqah';

  static const List<Map<String, String>> tips = [
    {
      'title': 'Give Sadaqah Regularly',
      'description': 'Even a small amount counts. Consistency is rewarded.'
    },
    {
      'title': 'Support Local Communities',
      'description': 'Donate to local mosques, orphanages, and food programs.'
    },
    {
      'title': 'Charity During Ramadan',
      'description': 'Good deeds and charity have multiplied rewards in Ramadan.'
    },
    {
      'title': 'Help the Needy',
      'description': 'Provide meals, water, or essentials to those in need.'
    },
  ];

  // Replace these with actual donation links or bank info
  static const String donationUrl = 'https://www.yourcharity.org/donate';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Charity & Sadaqah',
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
                  colors: [Colors.orange.shade400, Colors.deepOrange.shade700],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.volunteer_activism, size: 60, color: Colors.white),
                  const SizedBox(height: 12),
                  Text(
                    'Give Charity & Sadaqah',
                    style: context.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Your contributions during Ramadan help those in need and earn you great reward.',
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
                    child: const Icon(Icons.star, color: Colors.white),
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
            // Donate Button
            // ElevatedButton.icon(
            //   icon: const Icon(Icons.attach_money),
            //   label: const Text('Donate Now'),
            //   style: ElevatedButton.styleFrom(
            //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
            //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            //     backgroundColor: Colors.deepOrange,
            //   ),
            //   onPressed: () async {
            //     if (await canLaunchUrl(Uri.parse(donationUrl))) {
            //       await launchUrl(Uri.parse(donationUrl));
            //     } else {
            //       if(context.mounted) {
            //         ScaffoldMessenger.of(context).showSnackBar(
            //           const SnackBar(content: Text('Unable to open donation link')),
            //         );
            //       }
            //     }
            //   },
            // ),
          ],
        ),
      ),
    );
  }
}
