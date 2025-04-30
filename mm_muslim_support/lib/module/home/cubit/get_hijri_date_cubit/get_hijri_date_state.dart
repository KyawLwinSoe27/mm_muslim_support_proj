part of 'get_hijri_date_cubit.dart';

sealed class GetHijriDateState extends Equatable {
  const GetHijriDateState();

  @override
  List<Object> get props => [];
}

final class GetHijriDateInitial extends GetHijriDateState {}

final class GetHijriDateLoading extends GetHijriDateState {}

final class GetHijriDateLoaded extends GetHijriDateState {
  final TodayDateModel todayDate;

  const GetHijriDateLoaded(this.todayDate);

  @override
  List<Object> get props => [todayDate];
}

final class GetHijriDateError extends GetHijriDateState {
  final String error;

  const GetHijriDateError(this.error);

  @override
  List<Object> get props => [error];
}
