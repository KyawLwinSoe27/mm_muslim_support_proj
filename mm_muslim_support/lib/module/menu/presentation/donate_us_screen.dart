import 'package:flutter/material.dart';
import 'package:mm_muslim_support/utility/constants.dart';
import 'package:mm_muslim_support/utility/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class DonateUsScreen extends StatelessWidget {
  const DonateUsScreen({super.key});

  static const String routeName = '/donate-us';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Donate Us',
          style: context.textTheme.titleLarge?.copyWith(
            color: context.colorScheme.onSecondary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.volunteer_activism,
                size: 80,
                color: context.colorScheme.primary,
              ),
              const SizedBox(height: 20),
              Text(
                'Support Minara',
                style: context.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.primary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'Your donation helps us improve this app and bring more Islamic content and features to the global Muslim community.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              // const SizedBox(height: 30),
              // ElevatedButton.icon(
              //   icon: const Icon(Icons.favorite),
              //   label: const Text('Donate via PayPal'),
              //   onPressed: () {
              //     // Launch donation link
              //   },
              //   style: ElevatedButton.styleFrom(
              //     padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              //   ),
              // ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                icon: Icon(
                  Icons.monetization_on,
                  color: context.colorScheme.primary,
                ),
                label: Text('Donate', style: context.textTheme.titleMedium),
                onPressed: () {
                  // Show bank info dialog
                  showDialog(
                    context: context,
                    builder:
                        (context) => AlertDialog(
                          title: const Text('Contact Information'),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Developer Name: ${AppConstants.developerName}',
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Account Name: ${AppConstants.developerEmail}',
                              ),
                              const SizedBox(height: 16),
                              InkWell(
                                onTap: () async {
                                  // url opener
                                  // Open the phone dialer with the developer's phone number
                                  launchUrl(
                                    Uri.parse(
                                      'tel:${AppConstants.developerPhone}',
                                    ),
                                  );
                                },
                                child: const Text(
                                  'Account Number: ${AppConstants.developerPhone}',
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Close'),
                            ),
                          ],
                        ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
