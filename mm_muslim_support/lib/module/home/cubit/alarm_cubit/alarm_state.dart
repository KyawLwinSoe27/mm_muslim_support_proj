part of 'alarm_cubit.dart';

abstract class AlarmState extends Equatable {
  @override
  List<Object?> get props => [];
}

class AlarmInitial extends AlarmState {}

class AlarmLoaded extends AlarmState {
  final Map<Prayer, bool> alarms;

  AlarmLoaded(this.alarms);

  @override
  List<Object?> get props => [alarms];
}
