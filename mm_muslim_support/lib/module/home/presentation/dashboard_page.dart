import 'package:flutter/material.dart';
import 'package:mm_muslim_support/module/home/widgets/prayer_time_grid_widget.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          PrayerTimeGrid()
        ],
      ),
    );
  }
}
