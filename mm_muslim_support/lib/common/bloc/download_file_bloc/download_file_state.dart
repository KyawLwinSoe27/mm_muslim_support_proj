part of 'download_file_bloc.dart';

sealed class DownloadFileState extends Equatable {
  const DownloadFileState();

  @override
  List<Object?> get props => [];
}

class DownloadInitial extends DownloadFileState {}

class DownloadInProgress extends DownloadFileState {
  final int progress; // in percent

  const DownloadInProgress({required this.progress});
  @override
  List<Object?> get props => [progress];
}

class DownloadSuccess extends DownloadFileState {
  final String filePath;
  final int currentPage;

  const DownloadSuccess({required this.filePath, required this.currentPage});
}

class DownloadFailure extends DownloadFileState {
  final String message;

  const DownloadFailure({required this.message});
}
