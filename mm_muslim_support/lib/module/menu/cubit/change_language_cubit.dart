import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeLanguageCubit extends Cubit<bool> {
  ChangeLanguageCubit() : super(true);

  void toggleLanguage() {
    emit(!state);
  }
}
