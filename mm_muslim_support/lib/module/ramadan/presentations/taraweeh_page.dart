import 'package:flutter/material.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class TaraweehPage extends StatefulWidget {
  const TaraweehPage({super.key});

  static const String routeName = '/taraweeh';

  @override
  State<TaraweehPage> createState() => _TaraweehPageState();
}

class _TaraweehPageState extends State<TaraweehPage> {
  int completedRakat = 0;
  final int totalRakat = 20; // Typical Taraweeh rakats

  void _incrementRakat() {
    if (completedRakat < totalRakat) {
      setState(() {
        completedRakat++;
      });
    }
  }

  void _resetRakat() {
    setState(() {
      completedRakat = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double progress = completedRakat / totalRakat;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Taraweeh Tracker',
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colorScheme.onSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: context.colorScheme.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Circular progress
            Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 180,
                  height: 180,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 12,
                    backgroundColor: Colors.grey.shade300,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$completedRakat / $totalRakat',
                      style: context.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                    const Text('Rakat Completed'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _incrementRakat,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Next Rakat', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 20),
                OutlinedButton(
                  onPressed: _resetRakat,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.deepPurple,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    side: const BorderSide(color: Colors.deepPurple),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 40),
            // Tips section
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: const [
                    Text(
                      'Taraweeh Tips',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      '• Pray with focus and humility.\n'
                          '• Take short breaks between sets if needed.\n'
                          '• Recite Quran slowly and understand meanings.\n'
                          '• Encourage family members to join.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
