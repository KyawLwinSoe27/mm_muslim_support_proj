import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';

class HijriOffsetCubit extends Cubit<int> {
  HijriOffsetCubit() : super(_loadInitialOffset());

  static int _loadInitialOffset() {
    return SharedPreferenceService.getHijriOffset() ?? 0;
  }

  void changeOffset(int value) async {
    await SharedPreferenceService.setHijriOffset(value);
    emit(value);
  }

  void increase() {
    if (state < 2) {
      changeOffset(state + 1);
    }
  }

  void decrease() {
    if (state > -2) {
      changeOffset(state - 1);
    }
  }

  void reset() {
    changeOffset(0);
  }
}
