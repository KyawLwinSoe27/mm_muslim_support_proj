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

  void setCurrentSurah(QuranSongModel? quranSongModel) {
    currentSong = quranSongModel;
  }

  Future<void> stopAndClear() async {
    await audioHandler.stop();
    setCurrentSurah(null);
    emit(const AudioPlayerState.initial());
  }

  void seek(Duration position) {
    audioHandler.seek(position);
    emit(state.copyWith(position: position));
  }

  Future<void> setAudio(QuranSongModel surah) async {
    setCurrentSurah(surah);
    final song = currentSong;
    if (song == null) return;

    final MediaItem? mediaItem = await audioHandler.mediaItem.first;
    final PlaybackState playbackState = await audioHandler.playbackState.first;

    final String? currentSongId = mediaItem?.id;
    final String targetSongId = song.number.toString();

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
            currentSurahId: song.number,
          ),
        );
      }
      return;
    }

    await audioHandler.stop();

    if (!isClosed) {
      emit(
        state.copyWith(
          name: 'Surah ${song.name}',
          currentSurahId: song.number,
        ),
      );
    }

    await audioHandler.setUrl(song);
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
        final index = (state.currentSurahId - 1).clamp(0, surahList.length - 1);
        final nextSong = surahList[index];
        currentSong = nextSong;
        await setAudio(nextSong);
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
