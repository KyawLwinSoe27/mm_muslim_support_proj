import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/model/daily_quran_dua_model.dart';

class DailyQuranDuaCubit extends Cubit<DailyQuranDuaModel> {
  static const Duration rotationInterval = Duration(seconds: 30);

  final List<DailyQuranDuaModel> duaList;
  Timer? _timer;
  final Random _random = Random();

  DailyQuranDuaCubit(this.duaList) : super(duaList[0]) {
    _startRandomizer();
  }

  void _startRandomizer() {
    if (duaList.length <= 1) {
      return;
    }

    _timer = Timer.periodic(rotationInterval, (_) {
      _emitRandom();
    });
  }

  void _emitRandom() {
    final randomIndex = _random.nextInt(duaList.length);
    emit(duaList[randomIndex]);
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
