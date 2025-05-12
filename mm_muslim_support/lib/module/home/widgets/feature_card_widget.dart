import 'package:flutter/material.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class FeatureCardWidget extends StatelessWidget {
  const FeatureCardWidget({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 5),
          Text(title, style: context.textTheme.labelMedium),
        ],
      ),
    );
  }
}
