import 'package:equatable/equatable.dart';
import 'package:mm_muslim_support/models/ramadan_day_model.dart';
import 'package:mm_muslim_support/models/dua_model.dart';

abstract class RamadanTrackerState extends Equatable {
  const RamadanTrackerState();

  @override
  List<Object?> get props => [];
}

class RamadanTrackerInitial extends RamadanTrackerState {}

class RamadanTrackerLoaded extends RamadanTrackerState {
  final List<RamadanDayModel> schedule;
  final int currentDay;
  final List<DuaModel> duas;
  final String locationName;

  const RamadanTrackerLoaded({
    required this.schedule,
    required this.currentDay,
    required this.duas,
    required this.locationName,
  });

  @override
  List<Object?> get props => [schedule, currentDay, duas, locationName];
}
