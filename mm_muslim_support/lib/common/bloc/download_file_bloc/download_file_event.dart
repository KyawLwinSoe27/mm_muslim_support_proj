part of 'download_file_bloc.dart';

sealed class DownloadFileEvent extends Equatable {
  const DownloadFileEvent();

  @override
  List<Object?> get props => [];
}

class StartDownload extends DownloadFileEvent {
  final String url;
  final String fileName;

  const StartDownload({required this.url, required this.fileName});
}