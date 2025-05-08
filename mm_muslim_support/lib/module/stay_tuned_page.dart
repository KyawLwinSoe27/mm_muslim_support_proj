import 'package:flutter/material.dart';

class StayTunedPage extends StatelessWidget {
  const StayTunedPage({super.key});

  static const String routeName = '/stay_tuned_page';

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.notifications_active,
                size: 80.0,
              ),
              SizedBox(height: 20),
              Text(
                'Something exciting is coming soon!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              Text(
                'Stay tuned and keep an eye out for updates!',
                style: TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }
}
