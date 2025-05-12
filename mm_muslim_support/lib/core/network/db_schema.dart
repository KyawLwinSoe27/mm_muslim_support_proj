class DBTables {
  static const String bookmarks = 'bookmarks';
  static const String bookmarkPath = 'filePath';
  static const String id = 'id';

  static const String prayerTimes = 'prayer_times';
  static const String prayerTimeId = 'id';
  static const String prayerTimeDateTime = 'dateTime';
  static const String prayerTimeName = 'name';
  static const String prayerTimeTime = 'time';
  static const String prayerTimeDate = 'date';
  static const String alarmEnable = 'alarm';
}

class BookmarkTableSchema {
  static const String createTable = '''
    CREATE TABLE ${DBTables.bookmarks} (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      filePath TEXT NOT NULL,
      page INTEGER NOT NULL
    )
  ''';
}

class PrayerTimeTableSchema {
  static const String createTable = '''
    CREATE TABLE ${DBTables.prayerTimes} (
      ${DBTables.prayerTimeId} INTEGER PRIMARY KEY AUTOINCREMENT,
      ${DBTables.prayerTimeName} TEXT NOT NULL,
      ${DBTables.prayerTimeTime} TEXT NOT NULL,
      ${DBTables.prayerTimeDate} TEXT NOT NULL,
      ${DBTables.alarmEnable} INTEGER NOT NULL
    )
  ''';
}
