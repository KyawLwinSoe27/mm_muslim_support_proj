import 'package:equatable/equatable.dart';

class AudioPlayerState extends Equatable{
  final bool isPlaying;
  final Duration position;
  final Duration buffered;
  final Duration duration;

  const AudioPlayerState({
    required this.isPlaying,
    required this.position,
    required this.buffered,
    required this.duration,
  });

  const AudioPlayerState.initial()
      : isPlaying = false,
        position = Duration.zero,
        buffered = Duration.zero,
        duration = Duration.zero;

  AudioPlayerState copyWith({
    bool? isPlaying,
    Duration? position,
    Duration? buffered,
    Duration? duration,
  }) {
    return AudioPlayerState(
      isPlaying: isPlaying ?? this.isPlaying,
      position: position ?? this.position,
      buffered: buffered ?? this.buffered,
      duration: duration ?? this.duration,
    );
  }

  @override
  List<Object?> get props => [
    isPlaying,
    position,
    buffered,
    duration,
  ];
}
