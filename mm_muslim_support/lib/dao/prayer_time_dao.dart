import 'package:flutter/cupertino.dart';
import 'package:mm_muslim_support/core/network/app_database.dart';
import 'package:mm_muslim_support/core/network/db_queries.dart';
import 'package:mm_muslim_support/core/network/db_schema.dart';
import 'package:mm_muslim_support/model/custom_prayer_time.dart';
import 'package:sqflite/sqflite.dart';

class PrayerTimeDao {
  final dbProvider = AppDatabase();

  Future<void> insertBookmark(CustomPrayerTime prayerTime) async {
    final db = await dbProvider.database;
    await db.insert(DBTables.prayerTimes, prayerTime.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> updateBookmark(CustomPrayerTime prayerTime) async {
    final db = await dbProvider.database;
    try {
      await db.update(DBTables.prayerTimes, prayerTime.toMap(), where: '${DBTables.id} = ?', whereArgs: [prayerTime.id]);
    } catch(e, st) {
      debugPrintStack(stackTrace: st);
    }
  }

  Future<CustomPrayerTime?> getPrayerTimeByDateTime(String dateTime) async {
    final db = await dbProvider.database;
    final result = await db.rawQuery(PrayerTimeQueries.getPrayerTimeByDateTime, [dateTime]);
    if (result.isNotEmpty) {
      return CustomPrayerTime.fromMap(result.first);
    }
    return null;
  }

  // Future<void> deleteBookmark(String filePath) async {
  //   final db = await dbProvider.database;
  //   await db.rawDelete(BookmarkQueries.deleteBookmarkByPath, [filePath]);
  // }
}