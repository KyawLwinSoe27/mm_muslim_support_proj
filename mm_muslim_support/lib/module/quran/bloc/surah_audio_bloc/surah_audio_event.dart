part of 'surah_audio_bloc.dart';

abstract class SurahAudioEvent extends Equatable {
  const SurahAudioEvent();
  @override
  List<Object> get props => [];
}

class SurahAudioLoad extends SurahAudioEvent {
  final String name;
  final String url;
  const SurahAudioLoad(this.url, this.name);
}

class SurahAudioPlay extends SurahAudioEvent {}

class SurahAudioPause extends SurahAudioEvent {}

class SurahAudioUpdatePosition extends SurahAudioEvent {
  final Duration position;
  final Duration buffered;
  final Duration duration;

  const SurahAudioUpdatePosition(this.position, this.buffered, this.duration);

  @override
  List<Object> get props => [position, buffered, duration];
}

class SurahAudioCompleted extends SurahAudioEvent {}
