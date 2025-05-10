import 'package:flutter/material.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  static const String routeName = '/about-us';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('About Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Minara',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              'Minara is a comprehensive Islamic mobile app designed to help Muslims stay connected with their faith. We offer prayer time tracking, Quran reading and listening (with translations), Qibla direction, Islamic history, Tasbih, and more.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text(
              'Features:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...[
              '• Accurate Prayer Times by location',
              '• Alarm & Notifications',
              '• Quran with Myanmar Translation',
              '• Quran Audio Playback',
              '• Qibla Direction Finder',
              '• Islamic History & Discoveries',
              '• Tasbih Counter',
              '• Social Sharing (coming soon)'
            ].map((e) => Padding(
              padding: const EdgeInsets.only(bottom: 6.0),
              child: Text(e),
            )),
            const SizedBox(height: 20),
            const Text(
              'Contact: kyawlwinsoe812@gmail.com',
            )
          ],
        ),
      ),
    );
  }
}
