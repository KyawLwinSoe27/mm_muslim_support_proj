class BookmarkModel {
  final int? id;
  final String filePath;
  final int page;

  BookmarkModel({this.id, required this.filePath, required this.page});

  Map<String, dynamic> toMap() {
    return {'id': id, 'filePath': filePath, 'page': page};
  }

  factory BookmarkModel.fromMap(Map<String, dynamic> map) {
    return BookmarkModel(
      id: map['id'],
      filePath: map['filePath'],
      page: map['page'],
    );
  }
}
