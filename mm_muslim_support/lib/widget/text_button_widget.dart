import 'package:flutter/material.dart';
import 'package:mm_muslim_support/utility/extensions.dart';

class TextButtonWidget extends StatelessWidget {
  const TextButtonWidget({
    super.key,
    required this.onPressed,
    required this.text,
  });

  final Function() onPressed;
  final String text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Text(
        text,
        style: context.textTheme.labelSmall?.copyWith(
          color: context.colorScheme.primary,
        ),
      ),
    );
  }
}
