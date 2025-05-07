import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/model/book_model.dart';
import 'package:mm_muslim_support/repository/book_mark_repository.dart';

part 'book_mark_state.dart';

class BookMarkCubit extends Cubit<BookMarkState> {
  final BookmarkRepository _repository;
  BookMarkCubit([BookmarkRepository? bookMarkRepository]) : _repository = bookMarkRepository ?? BookmarkRepository(), super(BookMarkInitial());

  // Save a bookmark
  Future<void> saveBookMark(String filePath, int page) async {
    try {
      await _repository.saveBookmark(filePath, page);
      emit(SavedBookMark(status: page));
    } catch (e) {
      emit(BookMarkError(message: 'Failed to save bookmark: $e'));
    }
  }

  // Get a bookmark
  Future<int> getBookMark(String filePath) async {
    try {
      BookmarkModel? bookmark = await _repository.getBookmark(filePath);
      if (bookmark != null) {
        return bookmark.page;
      } else {
        return 1;
      }
    } catch (e) {
      return 1;
    }
  }
}