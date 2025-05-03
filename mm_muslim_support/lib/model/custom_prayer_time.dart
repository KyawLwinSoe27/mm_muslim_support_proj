class CustomPrayerTime {
  int id;
  final DateTime dateTime;
  final String prayerName;
  final String prayerTime;
  final int hour;
  final int minute;
  bool enableNotify;

  CustomPrayerTime({
    this.id = 0,
    required this.dateTime,
    required this.prayerName,
    required this.prayerTime,
    required this.hour,
    required this.minute,
    this.enableNotify = false,
  });
}