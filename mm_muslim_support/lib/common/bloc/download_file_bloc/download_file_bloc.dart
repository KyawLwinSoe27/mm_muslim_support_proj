import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:mm_muslim_support/core/enums/folder.dart';
import 'package:mm_muslim_support/repository/file_download_repository.dart';
import 'package:mm_muslim_support/service/file_management_service.dart';

part 'download_file_event.dart';
part 'download_file_state.dart';

class DownloadFileBloc extends Bloc<DownloadFileEvent, DownloadFileState> {
  final FileRepository _fileRepository;
  DownloadFileBloc([FileRepository? fileRepository]) : _fileRepository = fileRepository ?? FileRepositoryImplementation(), super(DownloadInitial()) {
    on<StartDownload>((event, emit) async {
      final dir = await FileManagementService.getDownloadDirectory(Folder.quran);
      final filePath = '${dir.path}/${event.fileName}';

      if (await File(filePath).exists()) {
        emit(DownloadSuccess(filePath: filePath));
        return;
      }

      try {
        emit(const DownloadInProgress(progress: 0));
        final filePath = await _fileRepository.downloadAndSaveFile(
          fileUrl: event.url,
          fileName: event.fileName,
          onReceiveProgress: (received, total) {
            final percent = (received / total * 100).floor();
            add(_UpdateProgress(percent));
          },
        );
        emit(DownloadSuccess(filePath: filePath));
      } catch (e) {
        emit(DownloadFailure(message: e.toString()));
      }
    });

    on<_UpdateProgress>((event, emit) {
      emit(DownloadInProgress(progress: event.percent));
    });
  }
}

class _UpdateProgress extends DownloadFileEvent {
  final int percent;

  const _UpdateProgress(this.percent);
}
