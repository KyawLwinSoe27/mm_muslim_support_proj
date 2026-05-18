import 'package:mm_muslim_support/core/network/app_database.dart';
import 'package:mm_muslim_support/core/network/db_schema.dart';
import 'package:mm_muslim_support/model/daily_quran_dua_model.dart';

class ContentCacheDao {
  final dbProvider = AppDatabase();

  Future<List<DailyQuranDuaModel>> getQuranVerses() async {
    final db = await dbProvider.database;
    final rows = await db.query(
      QuranVersesCacheTable.tableName,
      orderBy: '${ContentCacheTable.sortOrder} ASC',
    );
    return rows.map(_toModel).toList();
  }

  Future<List<DailyQuranDuaModel>> getDailyDuas() async {
    final db = await dbProvider.database;
    final rows = await db.query(
      DailyDuasCacheTable.tableName,
      orderBy: '${ContentCacheTable.sortOrder} ASC',
    );
    return rows.map(_toModel).toList();
  }

  Future<List<DailyQuranDuaModel>> getHadiths() async {
    final db = await dbProvider.database;
    final rows = await db.query(
      HadithsCacheTable.tableName,
      orderBy: '${ContentCacheTable.sortOrder} ASC',
    );
    return rows.map(_toModel).toList();
  }

  Future<void> replaceQuranVerses(List<DailyQuranDuaModel> items) async {
    final db = await dbProvider.database;
    await db.transaction((txn) async {
      await txn.delete(QuranVersesCacheTable.tableName);
      for (final item in items) {
        await txn.insert(QuranVersesCacheTable.tableName, _toRow(item));
      }
    });
  }

  Future<void> replaceDailyDuas(List<DailyQuranDuaModel> items) async {
    final db = await dbProvider.database;
    await db.transaction((txn) async {
      await txn.delete(DailyDuasCacheTable.tableName);
      for (final item in items) {
        await txn.insert(DailyDuasCacheTable.tableName, _toRow(item));
      }
    });
  }

  Future<void> replaceHadiths(List<DailyQuranDuaModel> items) async {
    final db = await dbProvider.database;
    await db.transaction((txn) async {
      await txn.delete(HadithsCacheTable.tableName);
      for (final item in items) {
        await txn.insert(HadithsCacheTable.tableName, _toRow(item));
      }
    });
  }

  DailyQuranDuaModel _toModel(Map<String, dynamic> row) => DailyQuranDuaModel(
    arabic: row[ContentCacheTable.arabic] as String,
    translation: row[ContentCacheTable.translation] as String,
    mmTranslation: row[ContentCacheTable.mmTranslation] as String? ?? '',
    reference: row[ContentCacheTable.reference] as String,
  );

  Map<String, dynamic> _toRow(DailyQuranDuaModel item) => {
    ContentCacheTable.firestoreId: item.reference,
    ContentCacheTable.arabic: item.arabic,
    ContentCacheTable.translation: item.translation,
    ContentCacheTable.mmTranslation: item.mmTranslation,
    ContentCacheTable.reference: item.reference,
    ContentCacheTable.sortOrder: 0,
    ContentCacheTable.updatedAt: DateTime.now().toIso8601String(),
  };
}
