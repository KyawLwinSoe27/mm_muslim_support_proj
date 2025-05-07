class BookmarkQueries {
  static const String getBookmarkByPath = '''
    SELECT * FROM bookmarks WHERE filePath = ?
  ''';

  static const String deleteBookmarkByPath = '''
    DELETE FROM bookmarks WHERE filePath = ?
  ''';
}