part of 'download_file_bloc.dart';

abstract class DownloadFileEvent extends Equatable {
  const DownloadFileEvent();

  @override
  List<Object> get props => [];
}

class StartDownload extends DownloadFileEvent {
  final String url;
  final String fileName;
  final Folder folder;

  const StartDownload({
    required this.url,
    required this.fileName,
    required this.folder,
  });

  @override
  List<Object> get props => [url, fileName, folder];
}

class _UpdateProgress extends DownloadFileEvent {
  final int percent;

  const _UpdateProgress(this.percent);

  @override
  List<Object> get props => [percent];
}

class CheckFileExist extends DownloadFileEvent {
  final String fileName;
  final Folder folder;

  const CheckFileExist({required this.fileName, required this.folder});

  @override
  List<Object> get props => [fileName, folder];
}
