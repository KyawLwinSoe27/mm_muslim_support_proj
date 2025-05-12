import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/service/shared_preference_service.dart';

class GetMadhabCubit extends Cubit<bool> {
  GetMadhabCubit() : super(true);

  void setMadhab(bool value) {
    SharedPreferenceService.setMadhab(value);
    emit(value);
  }

  void toggleMadhab() {
    bool value = !state;
    SharedPreferenceService.setMadhab(value);
    emit(value);
  }
}
