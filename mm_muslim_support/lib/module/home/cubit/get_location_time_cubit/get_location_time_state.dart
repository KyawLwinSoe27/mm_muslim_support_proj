part of 'get_location_time_cubit.dart';

sealed class GetLocationTimeState extends Equatable {
  const GetLocationTimeState();

  @override
  List<Object> get props => [];
}

final class GetLocationTimeInitial extends GetLocationTimeState {}

final class GetLocationTimeLoading extends GetLocationTimeState {}

final class GetLocationTimeLoaded extends GetLocationTimeState {
  final String location;
  final String date;
  final String currentPrayer;

  const GetLocationTimeLoaded({
    required this.location,
    required this.date,
    required this.currentPrayer,
  });
}

final class GetLocationTimeError extends GetLocationTimeState {
  final String error;

  const GetLocationTimeError(this.error);

  @override
  List<Object> get props => [error];
}
