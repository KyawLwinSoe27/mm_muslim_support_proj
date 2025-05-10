// import 'package:equatable/equatable.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:mm_muslim_support/service/audio_handler.dart';
//
// part 'surah_audio_event.dart';
// part 'surah_audio_state.dart';
//
// class SurahAudioBloc extends Bloc<SurahAudioEvent, SurahAudioState> {
//   final AudioPlayerHandler audioHandler;
//
//   SurahAudioBloc(this.audioHandler) : super(SurahAudioInitial()) {
//     on<SurahAudioLoad>(_onLoad);
//     on<SurahAudioPlay>(_onPlay);
//     on<SurahAudioPause>(_onPause);
//     // You can add state updates by listening to audioHandler.playbackState
//   }
//
//   Future<void> _onLoad(SurahAudioLoad event, Emitter<SurahAudioState> emit) async {
//     try {
//       emit(SurahAudioLoading());
//       await audioHandler.setUrl(event.quranSongModel);
//       await audioHandler.play();
//       emit(SurahAudioNameChanged(event.name));
//     } catch (e) {
//       emit(SurahAudioError(e.toString()));
//     }
//   }
//
//   Future<void> _onPlay(SurahAudioPlay event, Emitter<SurahAudioState> emit) async {
//     await audioHandler.play();
//     emit(SurahAudioPlaying());
//   }
//
//   Future<void> _onPause(SurahAudioPause event, Emitter<SurahAudioState> emit) async {
//     await audioHandler.pause();
//     emit(SurahAudioPaused());
//   }
//
//   @override
//   Future<void> close() {
//     audioHandler.stop();
//     return super.close();
//   }
// }
