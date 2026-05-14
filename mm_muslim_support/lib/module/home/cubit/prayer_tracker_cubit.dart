import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/dao/prayer_tracker_dao.dart';

class PrayerTrackerState {
  final List<PrayerStatus> prayers;
  final int streak;
  final String date;

  PrayerTrackerState({
    required this.prayers,
    this.streak = 0,
    required this.date,
  });
}

class PrayerStatus {
  final String name;
  final bool performed;

  PrayerStatus({required this.name, required this.performed});
}

class PrayerTrackerCubit extends Cubit<PrayerTrackerState> {
  final PrayerTrackerDao _dao = PrayerTrackerDao();

  PrayerTrackerCubit() : super(PrayerTrackerState(prayers: _defaultPrayers(), date: _today())) {
    _load();
  }

  static List<PrayerStatus> _defaultPrayers() => [
    PrayerStatus(name: 'Fajr', performed: false),
    PrayerStatus(name: 'Dhuhr', performed: false),
    PrayerStatus(name: 'Asr', performed: false),
    PrayerStatus(name: 'Maghrib', performed: false),
    PrayerStatus(name: 'Isha', performed: false),
  ];

  static String _today() {
    final now = DateTime.now();
    return '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
  }

  Future<void> _load() async {
    final records = await _dao.getRecordsForDate(state.date);
    final prayers = _defaultPrayers().map((p) {
      final record = records.where((r) => r['prayer_name'] == p.name).firstOrNull;
      return PrayerStatus(name: p.name, performed: record != null ? record['performed'] == 1 : false);
    }).toList();
    final streak = await _dao.getCurrentStreak();
    emit(PrayerTrackerState(prayers: prayers, streak: streak, date: state.date));
  }

  Future<void> togglePrayer(String name) async {
    final updated = state.prayers.map((p) {
      if (p.name == name) {
        final newPerformed = !p.performed;
        _dao.setPrayerPerformed(name, state.date, newPerformed);
        return PrayerStatus(name: p.name, performed: newPerformed);
      }
      return p;
    }).toList();
    final streak = await _dao.getCurrentStreak();
    emit(PrayerTrackerState(prayers: updated, streak: streak, date: state.date));
  }
}
