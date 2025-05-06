import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_tasbih_list_state.dart';

class GetTasbihListCubit extends Cubit<GetTasbihListState> {
  GetTasbihListCubit() : super(GetTasbihListInitial());
}
