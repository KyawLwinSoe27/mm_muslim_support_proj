import 'package:flutter/cupertino.dart';
import 'package:mm_muslim_support/core/network/app_database.dart';
import 'package:mm_muslim_support/core/network/db_queries.dart';
import 'package:mm_muslim_support/core/network/db_schema.dart';
import 'package:mm_muslim_support/model/book_model.dart';
import 'package:sqflite/sqflite.dart';

class BookmarkDao {
  final dbProvider = AppDatabase();

  Future<void> insertBookmark(BookmarkModel bookmark) async {
    final db = await dbProvider.database;
    await db.insert(
      DBTables.bookmarks,
      bookmark.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateBookmark(BookmarkModel bookmark) async {
    final db = await dbProvider.database;
    try {
      await db.update(
        DBTables.bookmarks,
        bookmark.toMap(),
        where: '${DBTables.id} = ?',
        whereArgs: [bookmark.id],
      );
    } catch (e, st) {
      debugPrintStack(stackTrace: st);
    }
  }

  Future<BookmarkModel?> getBookmarkByPath(String filePath) async {
    final db = await dbProvider.database;
    final result = await db.rawQuery(BookmarkQueries.getBookmarkByPath, [
      filePath,
    ]);
    if (result.isNotEmpty) {
      return BookmarkModel.fromMap(result.first);
    }
    return null;
  }

  Future<void> deleteBookmark(String filePath) async {
    final db = await dbProvider.database;
    await db.rawDelete(BookmarkQueries.deleteBookmarkByPath, [filePath]);
  }
}
