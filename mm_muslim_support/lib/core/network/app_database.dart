import 'package:mm_muslim_support/core/network/db_schema.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class AppDatabase {
  static final AppDatabase _instance = AppDatabase._internal();
  factory AppDatabase() => _instance;
  AppDatabase._internal();

  static Database? _database;

  Future<Database> get database async {
    return _database ??= await _initDatabase();
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'app_database.db');

    return await openDatabase(
      path,
      version: 4,
      onCreate: (db, version) async {
        await db.execute(BookmarkTableSchema.createTable);
        await db.execute(PrayerTimeTableSchema.createTable);
        await db.execute(PrayerTrackerTable.createTable);
        await db.execute(QuranVersesCacheTable.createTable);
        await db.execute(DailyDuasCacheTable.createTable);
        await db.execute(HadithsCacheTable.createTable);
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(PrayerTrackerTable.createTable);
        }
        if (oldVersion < 3) {
          await db.execute(QuranVersesCacheTable.createTable);
          await db.execute(DailyDuasCacheTable.createTable);
          await db.execute(HadithsCacheTable.createTable);
        }
        if (oldVersion < 4) {
          await db.execute('ALTER TABLE ${QuranVersesCacheTable.tableName} ADD COLUMN ${ContentCacheTable.mmTranslation} TEXT NOT NULL DEFAULT ""');
          await db.execute('ALTER TABLE ${DailyDuasCacheTable.tableName} ADD COLUMN ${ContentCacheTable.mmTranslation} TEXT NOT NULL DEFAULT ""');
          await db.execute('ALTER TABLE ${HadithsCacheTable.tableName} ADD COLUMN ${ContentCacheTable.mmTranslation} TEXT NOT NULL DEFAULT ""');
        }
      },
    );
  }
}
