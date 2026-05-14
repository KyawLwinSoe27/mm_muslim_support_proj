import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';

class HijriOffsetCubit extends Cubit<int> {
  HijriOffsetCubit() : super(_loadInitialOffset());

  static int _loadInitialOffset() {
    return SharedPreferenceService.getHijriOffset() ?? 0;
  }

  bool _pending = false;

  void changeOffset(int value) async {
    if (_pending) return;
    _pending = true;
    try {
      await SharedPreferenceService.setHijriOffset(value);
      emit(value);
    } finally {
      _pending = false;
    }
  }

  void increase() {
    if (state < 2 && !_pending) {
      changeOffset(state + 1);
    }
  }

  void decrease() {
    if (state > -2 && !_pending) {
      changeOffset(state - 1);
    }
  }

  void reset() {
    if (!_pending) {
      changeOffset(0);
    }
  }
}
