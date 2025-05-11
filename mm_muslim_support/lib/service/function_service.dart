
import 'package:flutter/cupertino.dart';
import 'package:mm_muslim_support/service/location_service.dart';
import 'package:mm_muslim_support/utility/dialog_utils.dart';
import 'package:prayers_times/prayers_times.dart';
import 'package:url_launcher/url_launcher.dart';

class FunctionService {
  static PrayerTimes getPrayerTime({DateTime? dateTime}) {
    double latitude = LocationService.getLatitude();
    double longitude = LocationService.getLongitude();
    String locationName = LocationService.getLocationName();

    // Define the geographical coordinates for the location
    Coordinates coordinates = Coordinates(
      latitude,
      longitude,
    );

    // Specify the calculation parameters for prayer times
    PrayerCalculationParameters params = PrayerCalculationMethod.karachi();
    params.madhab = PrayerMadhab.hanafi;

    // Create a PrayerTimes instance for the specified location
    PrayerTimes prayerTimes = PrayerTimes(
        coordinates: coordinates,
        calculationParameters: params,
        precision: true,
        locationName: locationName,
        dateTime: dateTime
    );

    return prayerTimes;
  }

  static Widget getLocationTimeWidget( {
    required String title,
    required String time,
    required String image,
    required List<Color> gradientColors,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: gradientColors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Image.asset(image),
          Text(title),
          Text(time),
        ],
      ),
    );
  }

  static String locationName(String timeZoneName) {
    return timeZoneName == 'Asia/Yangon' ? 'Asia/Rangoon' : timeZoneName;
  }

  static Future<void> findNearbyMosque(BuildContext context) async {
    const String query = 'mosque';
    final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps/search/?api=1&query=$query');

    try {
      final bool launched = await launchUrl(
        googleMapsUrl,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && context.mounted) {
        // fallback if launch silently fails
        DialogUtils.showWarningDialog(context, 'Your phone does not support opening Google Maps.');
      }
    } catch (e) {
      // Handle any errors that occur during the URL launch
      if (context.mounted) {
        DialogUtils.showWarningDialog(context, 'An error occurred while trying to open Google Maps.');
      }
    }

  }
}