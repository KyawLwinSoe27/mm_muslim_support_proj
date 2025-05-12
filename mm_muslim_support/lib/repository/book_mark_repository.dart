import 'package:mm_muslim_support/dao/book_mark_dao.dart';
import 'package:mm_muslim_support/model/book_model.dart';

class BookmarkRepository {
  final BookmarkDao _dao = BookmarkDao();

  Future<void> saveBookmark(String filePath, int page) async {
    // Check if the bookmark already exists
    BookmarkModel? existingBookmark = await getBookmark(filePath);
    if (existingBookmark != null) {
      return _dao.updateBookmark(
        BookmarkModel(id: existingBookmark.id, filePath: filePath, page: page),
      );
    }
    return _dao.insertBookmark(BookmarkModel(filePath: filePath, page: page));
  }

  Future<BookmarkModel?> getBookmark(String filePath) {
    return _dao.getBookmarkByPath(filePath);
  }

  Future<void> deleteBookmark(String filePath) {
    return _dao.deleteBookmark(filePath);
  }
}
