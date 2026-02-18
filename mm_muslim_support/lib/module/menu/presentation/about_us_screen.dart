import 'package:flutter/material.dart';
import 'package:mm_muslim_support/utility/constants.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const String routeName = '/about-us';

  @override
  Widget build(BuildContext context) {
    final theme = context.textTheme;
    final colors = context.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
        centerTitle: true,
        backgroundColor: colors.primary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // App Logo / Icon
            CircleAvatar(
              radius: 50,
              backgroundColor: colors.primary.withValues(alpha: 0.1),
              child: Icon(Icons.apps, size: 50, color: colors.primary),
            ),
            const SizedBox(height: 16),

            // App Name
            Text(
              'Minara',
              style: theme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: colors.primary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),

            // Description Card
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text(
                  'Minara is a comprehensive Islamic mobile app designed to help Muslims stay connected with their faith. We offer prayer time tracking, Quran reading and listening (with translations), Qibla direction, Islamic history, Tasbih, and more.',
                  style: theme.bodyMedium?.copyWith(height: 1.5),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Features
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Features',
                style: theme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold, color: colors.primary),
              ),
            ),
            const SizedBox(height: 12),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  children: [
                    FeatureTile(
                        icon: Icons.access_time_filled,
                        text: 'Accurate Prayer Times by location'),
                    FeatureTile(
                        icon: Icons.alarm, text: 'Alarm & Notifications'),
                    FeatureTile(
                        icon: Icons.book,
                        text: 'Quran with Myanmar Translation'),
                    FeatureTile(
                        icon: Icons.play_circle_fill,
                        text: 'Quran Audio Playback'),
                    FeatureTile(
                        icon: Icons.explore,
                        text: 'Qibla Direction Finder'),
                    FeatureTile(
                        icon: Icons.history_edu,
                        text: 'Islamic History & Discoveries (coming soon)'),
                    FeatureTile(
                        icon: Icons.countertops, text: 'Tasbih Counter'),
                    FeatureTile(
                        icon: Icons.share, text: 'Social Sharing (coming soon)'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Contact info
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(Icons.contact_mail, color: colors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Contact: ${AppConstants.developerEmail}',
                        style: theme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class FeatureTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const FeatureTile({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final colors = context.colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: colors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: context.textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}