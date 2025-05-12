class BookmarkQueries {
  static const String getBookmarkByPath = '''
    SELECT * FROM bookmarks WHERE filePath = ?
  ''';

  static const String deleteBookmarkByPath = '''
    DELETE FROM bookmarks WHERE filePath = ?
  ''';
}

class PrayerTimeQueries {
  static const String getPrayerTimeByDateTime = '''
    SELECT * FROM prayer_times WHERE dateTime = ?
  ''';
}
