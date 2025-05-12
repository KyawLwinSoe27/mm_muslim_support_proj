import 'package:flutter/material.dart';

extension StringExtensions on String? {
  bool get isNullOrEmpty => this == null || this!.isEmpty;
}

extension ContextExtensions on BuildContext {
  TextTheme get textTheme => Theme.of(this).textTheme;
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
}
