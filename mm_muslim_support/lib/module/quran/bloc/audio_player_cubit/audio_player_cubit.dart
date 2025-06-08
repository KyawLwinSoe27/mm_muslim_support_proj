import 'dart:async';
import 'package:audio_service/audio_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/main.dart';
import 'package:mm_muslim_support/model/quran_song_model.dart';
import 'package:mm_muslim_support/module/quran/bloc/audio_player_cubit/audio_player_state.dart';

class AudioPlayerCubit extends Cubit<AudioPlayerState> {
  AudioPlayerCubit() : super(const AudioPlayerState.initial());

  StreamSubscription? _playbackSubscription;
  StreamSubscription? _mediaItemSubscription;
  Timer? _positionTimer;
  bool isFinished = false;
  QuranSongModel? currentSong;

  void setCurrentSurah(QuranSongModel quranSongModel) {
    currentSong = quranSongModel;
  }

  void seek(Duration position) {
    audioHandler.seek(position);
    emit(state.copyWith(position: position));
  }

  Future<void> setAudio(QuranSongModel surah) async {
    setCurrentSurah(surah);
    final MediaItem? mediaItem = await audioHandler.mediaItem.first;
    final PlaybackState playbackState = await audioHandler.playbackState.first;

    final String? currentSongId = mediaItem?.id;
    final String targetSongId = currentSong!.number.toString();

    if (currentSongId != null && currentSongId == targetSongId) {
      _listenToPlaybackState();
      _startPositionTimer();

      if (!isClosed) {
        emit(
          state.copyWith(
            isPlaying: playbackState.playing,
            position: playbackState.position,
            buffered: playbackState.bufferedPosition,
            name: mediaItem?.title,
            currentSurahId: currentSong!.number,
          ),
        );
      }
      return;
    }

    await audioHandler.stop();

    if (!isClosed) {
      emit(
        state.copyWith(
          name: 'Surah ${currentSong!.name}',
          currentSurahId: currentSong!.number,
        ),
      );
    }

    await audioHandler.setUrl(currentSong!);
    _listenToPlaybackState();
    _startPositionTimer();
  }

  void _listenToPlaybackState() {
    _playbackSubscription?.cancel(); // Cancel old before assigning new
    _mediaItemSubscription?.cancel();

    _playbackSubscription = audioHandler.playbackState.listen((
      playbackState,
    ) async {
      if (isClosed) return;

      final isCompleted =
          playbackState.processingState == AudioProcessingState.completed;

      if (isCompleted && !isFinished) {
        isFinished = true;
        currentSong = surahList[state.currentSurahId];
        await setAudio(currentSong!);
        await audioHandler.play();
        isFinished = false;
      }

      if (!isClosed) {
        emit(
          state.copyWith(
            isPlaying: !isCompleted && playbackState.playing,
            position: playbackState.position,
            buffered: playbackState.bufferedPosition,
          ),
        );
      }
    });

    _mediaItemSubscription = audioHandler.mediaItem.listen((mediaItem) {
      if (isClosed) return;
      final duration = mediaItem?.duration ?? Duration.zero;
      emit(state.copyWith(duration: duration));
    });
  }

  void _startPositionTimer() {
    _positionTimer?.cancel();
    _positionTimer = Timer.periodic(const Duration(seconds: 1), (_) async {
      if (isClosed) return;
      final position = audioHandler.playbackState.value.position;
      emit(state.copyWith(position: position));
    });
  }

  void play() => isFinished ? audioHandler.replay() : audioHandler.play();
  void pause() => audioHandler.pause();

  @override
  Future<void> close() {
    _playbackSubscription?.cancel();
    _mediaItemSubscription?.cancel();
    _positionTimer?.cancel();
    return super.close();
  }
}
