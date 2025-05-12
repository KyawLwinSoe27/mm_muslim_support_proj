part of 'get_location_cubit.dart';

sealed class GetLocationState extends Equatable {
  const GetLocationState();
  @override
  List<Object> get props => [];
}

final class GetLocationInitial extends GetLocationState {}

final class GetLocationLoading extends GetLocationState {}

final class GetLocationLoaded extends GetLocationState {
  final String location;

  const GetLocationLoaded({required this.location});
}

final class GetLocationError extends GetLocationState {
  final String error;

  const GetLocationError(this.error);

  @override
  List<Object> get props => [error];
}
