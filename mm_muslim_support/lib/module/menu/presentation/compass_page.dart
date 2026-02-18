import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mm_muslim_support/utility/image_constants.dart';
import 'package:mm_muslim_support/widget/compass_painter.dart';
import 'package:prayers_times/prayers_times.dart';

class CompassPage extends StatefulWidget {
  const CompassPage({super.key});
  static const String routeName = '/compass';

  @override
  State<CompassPage> createState() => _CompassPageState();
}

class _CompassPageState extends State<CompassPage> {
  Future<Position>? getPosition;

  @override
  void initState() {
    super.initState();
    getPosition = _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: FutureBuilder<Position>(
        future: getPosition,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final position = snapshot.data!;
            final coordinates = Coordinates(position.latitude, position.longitude);
            final qiblaDirection = Qibla.qibla(coordinates);

            return StreamBuilder(
              stream: FlutterCompass.events,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                double? direction = snapshot.data!.heading;
                if (direction == null) {
                  return const Center(child: Text('Device does not have compass sensor.'));
                }

                final normalizedDirection = (direction + 360) % 360;

                return Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF0F2027), Color(0xFF203A43), Color(0xFF2C5364)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                  child: SafeArea(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: size.width,
                          height: size.width,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Compass Dial
                              CustomPaint(
                                size: Size(size.width, size.width),
                                painter: CompassCustomPainter(angle: normalizedDirection),
                              ),

                              // Qibla Pointer
                              Transform.rotate(
                                angle: (qiblaDirection - normalizedDirection) * pi / 180,
                                child: Column(
                                  children: [
                                    const Icon(
                                      Icons.arrow_drop_up,
                                      color: Colors.amberAccent,
                                      size: 60,
                                    ),
                                    Container(
                                      width: 4,
                                      height: size.width / 2 - 60,
                                      color: Colors.amberAccent.withOpacity(0.7),
                                    ),
                                  ],
                                ),
                              ),

                              // Kaaba Image at center
                              Positioned(
                                child: Image.asset(
                                  ImageConstants.kaaba,
                                  width: 80,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Heading Info Card
                        Card(
                          margin: const EdgeInsets.symmetric(horizontal: 24),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          color: Colors.black.withOpacity(0.5),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              children: [
                                Text(
                                  normalizedDirection.toInt() == qiblaDirection.toInt()
                                      ? "You're facing Makkah!"
                                      : 'Heading: ${normalizedDirection.toStringAsFixed(0)}°',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Qibla Direction: ${qiblaDirection.toStringAsFixed(0)}°',
                                  style: const TextStyle(
                                      color: Colors.white70, fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                        const Text(
                          'Rotate your device to align with the Qibla pointer',
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: CircularProgressIndicator(color: Colors.white));
        },
      ),
    );
  }
}

Future<Position> _determinePosition() async {
  bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) return Future.error('Location services are disabled.');

  LocationPermission permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) return Future.error('Location permissions are denied.');
  }

  if (permission == LocationPermission.deniedForever) {
    return Future.error('Location permissions are permanently denied.');
  }

  return await Geolocator.getCurrentPosition();
}
