import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/model/daily_quran_dua_model.dart';

class DailyQuranDuaCubit extends Cubit<DailyQuranDuaModel> {
  final List<DailyQuranDuaModel> duaList;
  late Timer _timer;
  final Random _random = Random();

  DailyQuranDuaCubit(this.duaList) : super(duaList[0]) {
    _startRandomizer();
  }

  void _startRandomizer() {
    _timer = Timer.periodic(const Duration(seconds: 30), (_) {
      _emitRandom();
    });
  }

  void _emitRandom() {
    final randomIndex = _random.nextInt(duaList.length);
    emit(duaList[randomIndex]);
  }

  @override
  Future<void> close() {
    _timer.cancel();
    return super.close();
  }
}
