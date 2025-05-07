class DBTables {
  static const String bookmarks = 'bookmarks';
  static const String bookmarkPath = 'filePath';
  static const String id = 'id';
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