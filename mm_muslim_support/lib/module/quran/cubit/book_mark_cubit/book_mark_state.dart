part of 'book_mark_cubit.dart';

sealed class BookMarkState extends Equatable {
  const BookMarkState();

  @override
  List<Object> get props => [];
}

final class BookMarkInitial extends BookMarkState {}

final class BookMarkLoading extends BookMarkState {}

final class SavedBookMark extends BookMarkState {
  final int status;

  const SavedBookMark({required this.status});

  @override
  List<Object> get props => [status];
}

final class BookMarkLoaded extends BookMarkState {
  final BookmarkModel bookmarks;

  const BookMarkLoaded({required this.bookmarks});

  @override
  List<Object> get props => [bookmarks];
}

final class BookMarkError extends BookMarkState {
  final String message;

  const BookMarkError({required this.message});

  @override
  List<Object> get props => [message];
}