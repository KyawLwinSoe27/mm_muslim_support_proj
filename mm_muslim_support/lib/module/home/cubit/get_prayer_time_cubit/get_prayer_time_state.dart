part of 'get_prayer_time_cubit.dart';

sealed class GetPrayerTimeState extends Equatable {
  const GetPrayerTimeState();

  @override
  List<Object> get props => [];
}

final class GetPrayerTimeInitial extends GetPrayerTimeState {}

final class GetPrayerTimeLoading extends GetPrayerTimeState {}

final class GetPrayerTimeLoaded extends GetPrayerTimeState {
  final List<PrayerTimeCard> prayerTimes;

  const GetPrayerTimeLoaded(this.prayerTimes);

  @override
  List<Object> get props => [prayerTimes];
}

final class GetPrayerTimeError extends GetPrayerTimeState {
  final String error;

  const GetPrayerTimeError(this.error);

  @override
  List<Object> get props => [error];
}

final class GetPrayerTimeByDateLoaded extends GetPrayerTimeState {
  final List<CustomPrayerTime> prayerTimes;
  final int timeStamp;

  const GetPrayerTimeByDateLoaded({
    required this.prayerTimes,
    required this.timeStamp,
  });

  @override
  List<Object> get props => [prayerTimes, timeStamp];
}

final class GetPrayerTimeByDateLoading extends GetPrayerTimeState {}

final class GetPrayerTimeByDateError extends GetPrayerTimeState {
  final String error;

  const GetPrayerTimeByDateError(this.error);

  @override
  List<Object> get props => [error];
}
