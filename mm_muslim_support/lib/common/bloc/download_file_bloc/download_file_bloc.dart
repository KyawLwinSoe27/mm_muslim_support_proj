import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/core/enums/folder.dart';
import 'package:mm_muslim_support/repository/book_mark_repository.dart';
import 'package:mm_muslim_support/repository/file_download_repository.dart';
import 'package:mm_muslim_support/service/file_management_service.dart';

part 'download_file_event.dart';
part 'download_file_state.dart';

class DownloadFileBloc extends Bloc<DownloadFileEvent, DownloadFileState> {
  final FileRepository _fileRepository;
  final BookmarkRepository _bookmarkRepository;

  DownloadFileBloc({FileRepository? fileRepository, BookmarkRepository? bookmarkRepository})
    : _fileRepository = fileRepository ?? FileRepositoryImplementation(),
      _bookmarkRepository = bookmarkRepository ?? BookmarkRepository(),
      super(DownloadInitial()) {
    on<StartDownload>(_onStartDownload);
    on<_UpdateProgress>(_onUpdateProgress);
    on<CheckFileExist>(_onCheckFileExist);
  }

  Future<void> _onStartDownload(StartDownload event, Emitter<DownloadFileState> emit) async {
    try {
      final dir = await FileManagementService.getDownloadDirectory(event.folder);
      final filePath = '${dir.path}/${event.fileName}';

      // File already exists
      if (await File(filePath).exists()) {
        int page = 1;
        if (event.folder == Folder.quran) {
          final bookmark = await _bookmarkRepository.getBookmark(filePath);
          if (bookmark != null) {
            page = bookmark.page;
          }
        }
        emit(DownloadSuccess(filePath: filePath, currentPage: page));
        return;
      }

      emit(const DownloadInProgress(progress: 0));

      final downloadedPath = await _fileRepository.downloadAndSaveFile(
        fileUrl: event.url,
        fileName: event.fileName,
        folder: event.folder,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            final percent = (received / total * 100).floor();
            add(_UpdateProgress(percent));
          }
        },
      );

      emit(DownloadSuccess(filePath: downloadedPath, currentPage: 1));
    } catch (e) {
      emit(DownloadFailure(message: e.toString()));
    }
  }

  void _onUpdateProgress(_UpdateProgress event, Emitter<DownloadFileState> emit) {
    emit(DownloadInProgress(progress: event.percent));
  }

  FutureOr<void> _onCheckFileExist(CheckFileExist event, Emitter<DownloadFileState> emit) async{
    final dir = await FileManagementService.getDownloadDirectory(event.folder);
    final filePath = '${dir.path}/${event.fileName}';

    if (await File(filePath).exists()) {
      return emit(const FileExist(isExist: true));
    } else {
      return emit(const FileExist(isExist: false));
    }
  }
}
