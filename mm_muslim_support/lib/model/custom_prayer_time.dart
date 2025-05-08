class CustomPrayerTime {
  int id;
  final DateTime dateTime;
  final String prayerName;
  final String prayerTime;
  final DateTime prayerDateTime;
  bool enableNotify;

  CustomPrayerTime({
    this.id = 0,
    required this.dateTime,
    required this.prayerName,
    required this.prayerTime,
    required this.prayerDateTime,
    this.enableNotify = false,
  });
}