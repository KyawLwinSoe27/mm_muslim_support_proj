import 'package:equatable/equatable.dart';

class AudioPlayerState extends Equatable{
  final bool isPlaying;
  final Duration position;
  final Duration buffered;
  final Duration duration;
  final String name;
  final int currentSurahId;

  const AudioPlayerState({
    required this.isPlaying,
    required this.position,
    required this.buffered,
    required this.duration,
    required this.name,
    required this.currentSurahId,
  });

  const AudioPlayerState.initial()
      : isPlaying = false,
        position = Duration.zero,
        buffered = Duration.zero,
        name = '',
        currentSurahId = 0,
        duration = Duration.zero;

  AudioPlayerState copyWith({
    bool? isPlaying,
    Duration? position,
    Duration? buffered,
    String? name,
    Duration? duration,
    int? currentSurahId,
  }) {
    return AudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      buffered: buffered ?? this.buffered,
      duration: duration ?? this.duration,
      name: name ?? this.name,
      currentSurahId: currentSurahId ?? this.currentSurahId,
    );
  }

  @override
  List<Object?> get props => [
    isPlaying,
    position,
    buffered,
    name,
    duration,
    currentSurahId,
  ];
}
