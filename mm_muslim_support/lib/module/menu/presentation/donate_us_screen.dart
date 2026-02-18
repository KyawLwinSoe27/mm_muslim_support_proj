import 'package:flutter/material.dart';
import 'package:mm_muslim_support/utility/constants.dart';
import 'package:mm_muslim_support/utility/extensions.dart';
import 'package:url_launcher/url_launcher.dart';

class DonateUsScreen extends StatelessWidget {
  const DonateUsScreen({super.key});

  static const String routeName = '/donate-us';

  @override
  Widget build(BuildContext context) {
    final theme = context;
    final colors = context.colorScheme;

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          // Gradient background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colors.primary.withValues(alpha: 0.8), colors.secondary],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Header Card
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      elevation: 6,
                      shadowColor: colors.primary.withValues(alpha: 0.4),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 32, horizontal: 24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.volunteer_activism,
                              size: 80,
                              color: colors.primary,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Support Minara',
                              style:
                              theme.textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: colors.primary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Your donation helps us improve this app and bring more Islamic content and features to the global Muslim community.',
                              textAlign: TextAlign.center,
                              style:
                              theme.textTheme.bodyMedium?.copyWith(
                                color: colors.onSurfaceVariant,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Donate via Bank
                    OutlinedButton.icon(
                      icon: Icon(Icons.monetization_on, color: colors.onSecondary),
                      label: const Text(
                        'Donate',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: colors.onSecondary,
                        side: BorderSide(color: colors.onSecondary, width: 2),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 24),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                      onPressed: () {
                        // Show bank info dialog
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Contact Information'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                    'Developer Name: ${AppConstants.developerName}'),
                                const SizedBox(height: 8),
                                const Text(
                                    'Account Name: ${AppConstants.developerEmail}'),
                                const SizedBox(height: 16),
                                InkWell(
                                  onTap: () async {
                                    final url = Uri.parse(
                                        'tel:${AppConstants.developerPhone}');
                                    if (await canLaunchUrl(url)) {
                                      await launchUrl(url);
                                    }
                                  },
                                  child: Text(
                                    'Account Number: ${AppConstants.developerPhone}',
                                    style: TextStyle(
                                      color: colors.primary,
                                      decoration: TextDecoration.underline,
                                    ),
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
                    const SizedBox(height: 32),

                    // Footer
                    Text(
                      'JazakAllahu Khair for your support!',
                      style: theme.textTheme.bodyLarge
                          ?.copyWith(color: colors.onPrimaryContainer),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}