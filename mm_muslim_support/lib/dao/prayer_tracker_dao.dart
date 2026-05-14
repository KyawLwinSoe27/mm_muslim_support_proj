import 'package:mm_muslim_support/core/network/app_database.dart';
import 'package:mm_muslim_support/core/network/db_schema.dart';

class PrayerTrackerDao {
  final AppDatabase _db = AppDatabase();

  Future<List<Map<String, dynamic>>> getRecordsForDate(String date) async {
    final db = await _db.database;
    return db.query(
      PrayerTrackerTable.tableName,
      where: '${PrayerTrackerTable.date} = ?',
      whereArgs: [date],
    );
  }

  Future<void> setPrayerPerformed(String prayerName, String date, bool performed) async {
    final db = await _db.database;
    final existing = await db.query(
      PrayerTrackerTable.tableName,
      where: '${PrayerTrackerTable.prayerName} = ? AND ${PrayerTrackerTable.date} = ?',
      whereArgs: [prayerName, date],
    );

    if (existing.isEmpty) {
      await db.insert(PrayerTrackerTable.tableName, {
        PrayerTrackerTable.prayerName: prayerName,
        PrayerTrackerTable.date: date,
        PrayerTrackerTable.performed: performed ? 1 : 0,
      });
    } else {
      await db.update(
        PrayerTrackerTable.tableName,
        {PrayerTrackerTable.performed: performed ? 1 : 0},
        where: '${PrayerTrackerTable.prayerName} = ? AND ${PrayerTrackerTable.date} = ?',
        whereArgs: [prayerName, date],
      );
    }
  }

  Future<int> getCurrentStreak() async {
    final db = await _db.database;
    final rows = await db.rawQuery('''
      SELECT DISTINCT ${PrayerTrackerTable.date} FROM ${PrayerTrackerTable.tableName}
      WHERE ${PrayerTrackerTable.performed} = 1
      ORDER BY ${PrayerTrackerTable.date} DESC
    ''');

    final dates = rows.map((r) => r[PrayerTrackerTable.date] as String).toSet().toList()..sort((a, b) => b.compareTo(a));

    if (dates.isEmpty) return 0;

    int streak = 0;
    final today = DateTime.now();
    var checkDate = today;

    for (int i = 0; i < 365; i++) {
      final dateStr = _dateToString(checkDate);
      if (dates.contains(dateStr)) {
        streak++;
        checkDate = checkDate.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }
    return streak;
  }

  String _dateToString(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}
