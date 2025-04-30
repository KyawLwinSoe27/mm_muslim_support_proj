import 'package:flutter/material.dart';

class PrayerTimeCard {
  final String title;
  final String? subtitle;
  final String time;
  final String image;
  final List<Color> gradientColors;

  const PrayerTimeCard({
    required this.title,
    this.subtitle,
    required this.time,
    required this.image,
    required this.gradientColors,
  });
}