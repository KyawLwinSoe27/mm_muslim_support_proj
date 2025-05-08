part of 'download_file_bloc.dart';

abstract class DownloadFileState extends Equatable {
  const DownloadFileState();

  @override
  List<Object?> get props => [];
}

class DownloadInitial extends DownloadFileState {}

class DownloadInProgress extends DownloadFileState {
  final int progress;

  const DownloadInProgress({required this.progress});

  @override
  List<Object?> get props => [progress];
}

class DownloadSuccess extends DownloadFileState {
  final String filePath;
  final int currentPage; // Optional for PDF use case

  const DownloadSuccess({required this.filePath, required this.currentPage});

  @override
  List<Object?> get props => [filePath, currentPage];
}

class DownloadFailure extends DownloadFileState {
  final String message;

  const DownloadFailure({required this.message});

  @override
  List<Object?> get props => [message];
}
