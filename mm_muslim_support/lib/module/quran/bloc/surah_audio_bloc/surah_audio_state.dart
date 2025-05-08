part of 'surah_audio_bloc.dart';

abstract class SurahAudioState extends Equatable {
  const SurahAudioState();
  @override
  List<Object?> get props => [];
}

class SurahAudioInitial extends SurahAudioState {}

class SurahAudioLoading extends SurahAudioState {}

class SurahAudioPlaying extends SurahAudioState {
  final Duration position;
  final Duration buffered;
  final Duration duration;

  const SurahAudioPlaying(this.position, this.buffered, this.duration);

  @override
  List<Object?> get props => [position, buffered, duration];
}

class SurahAudioError extends SurahAudioState {
  final String message;
  const SurahAudioError(this.message);

  @override
  List<Object?> get props => [message];
}

class SurahAudioPaused extends SurahAudioState {
  final Duration position;
  final Duration buffered;
  final Duration duration;

  const SurahAudioPaused(this.position, this.buffered, this.duration);

  @override
  List<Object?> get props => [position, buffered, duration];
}

class SurahAudioFinished extends SurahAudioState {}
