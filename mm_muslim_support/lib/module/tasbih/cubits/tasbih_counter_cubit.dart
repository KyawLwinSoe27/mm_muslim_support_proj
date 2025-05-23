import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/utility/audio_constants.dart';

class TasbihCounterState {
  final int count;
  final int tasbihIndex;
  final bool finished;

  TasbihCounterState({
    required this.count,
    required this.tasbihIndex,
    required this.finished,
  });
}

class TasbihCounterCubit extends Cubit<TasbihCounterState> {
  TasbihCounterCubit()
    : super(TasbihCounterState(count: 0, tasbihIndex: 0, finished: false));

  TasbihCounterState get count => state;

  int total = 0;
  int tasbihListLength = 0;

  void setTotal(int total) {
    this.total = total;
  }

  void increment(int tasbihIndex) async {
    // final shortPlayer =
    //     AudioPlayer(); // Create a new player instance for short sound
    // await shortPlayer.play(
    //   AssetSource(AudioConstants.buttonTap),
    //   mode: PlayerMode.lowLatency,
    // );
    if (state.count > 0 && state.count == total) {
      if (state.tasbihIndex == tasbihListLength - 1) {
        emit(TasbihCounterState(count: 0, tasbihIndex: 0, finished: true));
        return;
      } else {
        emit(
          TasbihCounterState(
            count: 0,
            tasbihIndex: tasbihIndex + 1,
            finished: false,
          ),
        );
        return;
      }
    }

    emit(
      TasbihCounterState(
        count: state.count + 1,
        tasbihIndex: tasbihIndex,
        finished: false,
      ),
    );
  }

  void reset() {
    HapticFeedback.vibrate();
    final shortPlayer =
        AudioPlayer(); // Create a new player instance for short sound
    shortPlayer.play(
      AssetSource(AudioConstants.clearTap),
      mode: PlayerMode.lowLatency,
    );
    emit(
      TasbihCounterState(
        count: 0,
        tasbihIndex: state.tasbihIndex,
        finished: false,
      ),
    );
  }
}
