import 'package:prayers_times/prayers_times.dart';

enum PrayerCalculationMethodType {
  muslimWorldLeague,
  egyptian,
  karachi,
  ummAlQura,
  dubai,
  moonsightingCommittee,
  northAmerica,
  kuwait,
  qatar,
  singapore,
  tehran,
  turkey,
  morocco,
}

class PrayerCalculationMethod {
  final String name;
  final PrayerCalculationMethodType key;
  final double fajrAngle;
  final double ishaAngle;
  final double ishaInterval;

  const PrayerCalculationMethod({
    required this.name,
    required this.key,
    required this.fajrAngle,
    required this.ishaAngle,
    this.ishaInterval = 0.0,
  });
}

List<PrayerCalculationMethod> prayerCalculationMethods = const [
  PrayerCalculationMethod(
    name: 'Muslim World League',
    key: PrayerCalculationMethodType.muslimWorldLeague,
    fajrAngle: 18.0,
    ishaAngle: 17.0,
  ),
  PrayerCalculationMethod(
    name: 'Egyptian General Authority of Survey',
    key: PrayerCalculationMethodType.egyptian,
    fajrAngle: 19.5,
    ishaAngle: 17.5,
  ),
  PrayerCalculationMethod(
    name: 'University of Islamic Sciences, Karachi',
    key: PrayerCalculationMethodType.karachi,
    fajrAngle: 18.0,
    ishaAngle: 18.0,
  ),
  PrayerCalculationMethod(
    name: 'Umm al-Qura University, Makkah',
    key: PrayerCalculationMethodType.ummAlQura,
    fajrAngle: 18.5,
    ishaAngle: 0.0,
    ishaInterval: 90.0,
  ),
  PrayerCalculationMethod(
    name: 'Dubai',
    key: PrayerCalculationMethodType.dubai,
    fajrAngle: 18.2,
    ishaAngle: 18.2,
  ),
  PrayerCalculationMethod(
    name: 'Moonsighting Committee',
    key: PrayerCalculationMethodType.moonsightingCommittee,
    fajrAngle: 18.0,
    ishaAngle: 18.0,
  ),
  PrayerCalculationMethod(
    name: 'ISNA (Islamic Society of North America)',
    key: PrayerCalculationMethodType.northAmerica,
    fajrAngle: 15.0,
    ishaAngle: 15.0,
  ),
  PrayerCalculationMethod(
    name: 'Kuwait',
    key: PrayerCalculationMethodType.kuwait,
    fajrAngle: 18.0,
    ishaAngle: 17.5,
  ),
  PrayerCalculationMethod(
    name: 'Qatar',
    key: PrayerCalculationMethodType.qatar,
    fajrAngle: 18.0,
    ishaAngle: 0.0,
    ishaInterval: 90.0,
  ),
  PrayerCalculationMethod(
    name: 'Singapore',
    key: PrayerCalculationMethodType.singapore,
    fajrAngle: 20.0,
    ishaAngle: 18.0,
  ),
  PrayerCalculationMethod(
    name: 'Institute of Geophysics, University of Tehran',
    key: PrayerCalculationMethodType.tehran,
    fajrAngle: 17.7,
    ishaAngle: 14.0,
  ),
  PrayerCalculationMethod(
    name: 'Dianet (Turkey)',
    key: PrayerCalculationMethodType.turkey,
    fajrAngle: 18.0,
    ishaAngle: 17.0,
  ),
  PrayerCalculationMethod(
    name: 'Moroccan Ministry of Habous and Islamic Affairs',
    key: PrayerCalculationMethodType.morocco,
    fajrAngle: 19.0,
    ishaAngle: 17.0,
  ),
];
PrayerCalculationParameters getPrayerCalculationMethod(
  PrayerCalculationMethodType keyName,
) {
  switch (keyName) {
    case PrayerCalculationMethodType.muslimWorldLeague:
      return PrayerCalculationParameters('MuslimWorldLeague', 18.0, 17.0)
        ..methodAdjustments = {'dhuhr': 1};

    case PrayerCalculationMethodType.egyptian:
      return PrayerCalculationParameters('Egyptian', 19.5, 17.5)
        ..methodAdjustments = {'dhuhr': 1};

    case PrayerCalculationMethodType.karachi:
      return PrayerCalculationParameters('Karachi', 18.0, 18.0)
        ..methodAdjustments = {'dhuhr': 1};

    case PrayerCalculationMethodType.ummAlQura:
      return PrayerCalculationParameters(
        'UmmAlQura',
        18.5,
        0,
        ishaInterval: 90,
      );

    case PrayerCalculationMethodType.dubai:
      return PrayerCalculationParameters('Dubai', 18.2, 18.2)
        ..methodAdjustments = {
          'sunrise': -3,
          'dhuhr': 3,
          'asr': 3,
          'maghrib': 3,
        };

    case PrayerCalculationMethodType.moonsightingCommittee:
      return PrayerCalculationParameters('MoonsightingCommittee', 18.0, 18.0)
        ..methodAdjustments = {'dhuhr': 5, 'maghrib': 3};

    case PrayerCalculationMethodType.northAmerica:
      return PrayerCalculationParameters('NorthAmerica', 15.0, 15.0)
        ..methodAdjustments = {'dhuhr': 1};

    case PrayerCalculationMethodType.kuwait:
      return PrayerCalculationParameters('Kuwait', 18.0, 17.5);

    case PrayerCalculationMethodType.qatar:
      return PrayerCalculationParameters('Qatar', 18.0, 0.0, ishaInterval: 90);

    case PrayerCalculationMethodType.singapore:
      return PrayerCalculationParameters('Singapore', 20.0, 18.0)
        ..methodAdjustments = {'dhuhr': 1};

    case PrayerCalculationMethodType.tehran:
      return PrayerCalculationParameters(
        'Tehran',
        17.7,
        14.0,
        ishaInterval: 0,
        maghribAngle: 4.5,
      );

    case PrayerCalculationMethodType.turkey:
      return PrayerCalculationParameters('Turkey', 18.0, 17.0)
        ..methodAdjustments = {
          'sunrise': -7,
          'dhuhr': 5,
          'asr': 4,
          'maghrib': 7,
        };

    case PrayerCalculationMethodType.morocco:
      return PrayerCalculationParameters('Morocco', 19.0, 17.0)
        ..methodAdjustments = {'sunrise': -3, 'dhuhr': 5, 'maghrib': 5};
  }
}
