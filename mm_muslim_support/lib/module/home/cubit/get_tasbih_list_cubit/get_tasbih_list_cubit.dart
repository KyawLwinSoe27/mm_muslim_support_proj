import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'get_tasbih_list_state.dart';

class GetTasbihListCubit extends Cubit<GetTasbihListState> {
  GetTasbihListCubit() : super(GetTasbihListInitial());
}
