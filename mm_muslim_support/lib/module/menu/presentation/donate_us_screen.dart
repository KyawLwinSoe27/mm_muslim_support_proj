import 'package:flutter/material.dart';

class DonateUsScreen extends StatelessWidget {
  const DonateUsScreen({super.key});

  static const String routeName = '/donate-us';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Donate Us'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const Icon(Icons.volunteer_activism, size: 80),
            const SizedBox(height: 20),
            const Text(
              'Support Minara',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Text(
              'Your donation helps us improve this app and bring more Islamic content and features to the global Muslim community.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              icon: const Icon(Icons.favorite),
              label: const Text('Donate via PayPal'),
              onPressed: () {
                // Launch donation link
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              icon: const Icon(Icons.monetization_on),
              label: const Text('Donate via Bank'),
              onPressed: () {
                // Show bank info dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Bank Information'),
                    content: const Text('Bank: Example Bank\nAccount: 123456789\nName: Minara'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                    ],
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
