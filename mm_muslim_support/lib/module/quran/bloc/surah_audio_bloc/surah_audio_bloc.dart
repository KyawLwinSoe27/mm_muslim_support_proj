import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:just_audio/just_audio.dart';

part 'surah_audio_event.dart';
part 'surah_audio_state.dart';

class SurahAudioBloc extends Bloc<SurahAudioEvent, SurahAudioState> {
  final AudioPlayer _player = AudioPlayer();
  late final StreamSubscription<Duration> _positionSub;
  late final StreamSubscription<PlayerState> _playerStateSub;
  late final StreamSubscription<Duration> _bufferedSub;
  bool _isFinished = false;

  SurahAudioBloc() : super(SurahAudioInitial()) {
    on<SurahAudioLoad>(_onLoad);
    on<SurahAudioPlay>(_onPlay);
    on<SurahAudioPause>(_onPause);
    on<SurahAudioUpdatePosition>(_onPositionUpdated);
    on<SurahAudioCompleted>((event, emit) {
      emit(SurahAudioFinished());
    });




    _positionSub = _player.positionStream.listen((pos) {
      if(_isFinished) return;
      add(SurahAudioUpdatePosition(pos, _player.bufferedPosition, _player.duration ?? Duration.zero));
    });

    _bufferedSub = _player.bufferedPositionStream.listen((_) {
      if(_isFinished) return;
      // when buffered position finished not to update
      if (_player.bufferedPosition != _player.duration) {
        add(SurahAudioUpdatePosition(_player.position, _player.bufferedPosition, _player.duration ?? Duration.zero));
      }
    });

    _playerStateSub = _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        _isFinished = true;
        _player.seek(Duration.zero);
        _player.pause();
        add(SurahAudioCompleted());
      }
    });
  }

  Future<void> _onLoad(SurahAudioLoad event, Emitter<SurahAudioState> emit) async {
    print('[DEBUG] _onLoad called with URL: ${event.url}');
    try {
      _isFinished = false; // Reset finish flag
      emit(SurahAudioLoading());
      await _player.setAudioSource(AudioSource.uri(Uri.parse(event.url)));
      await _player.play();
      emit(SurahAudioNameChanged(event.name));
    } catch (e, st) {
      emit(SurahAudioError(st.toString()));
    }
  }

  Future<void> _onPlay(SurahAudioPlay event, Emitter<SurahAudioState> emit) async {
    _isFinished = false; // Reset if user taps play again
    await _player.play();
    emit(SurahAudioPlaying(
      _player.position,
      _player.bufferedPosition,
      _player.duration ?? Duration.zero,
    ));
  }

  Future<void> _onPause(SurahAudioPause event, Emitter<SurahAudioState> emit) async {
    await _player.pause();
    emit(SurahAudioPaused(
      _player.position,
      _player.bufferedPosition,
      _player.duration ?? Duration.zero,
    ));
  }

  void _onPositionUpdated(SurahAudioUpdatePosition event, Emitter<SurahAudioState> emit) {
    if (_isFinished) return; // Prevent override
    emit(SurahAudioPlaying(event.position, event.buffered, event.duration));
  }


  @override
  Future<void> close() {
    _positionSub.cancel();
    _playerStateSub.cancel();
    _bufferedSub.cancel();
    _player.dispose();
    return super.close();
  }
}
