part of 'ramadan_cubit.dart';

class RamadanState extends Equatable {
  final DateTime? sehriTime;
  final DateTime? iftarTime;
  final Duration remainingTime;
  final bool isSehriCountdown;

  const RamadanState({
    required this.sehriTime,
    required this.iftarTime,
    required this.remainingTime,
    required this.isSehriCountdown,
  });

  factory RamadanState.initial() {
    return const RamadanState(
      sehriTime: null,
      iftarTime: null,
      remainingTime: Duration.zero,
      isSehriCountdown: true,
    );
  }

  RamadanState copyWith({
    DateTime? sehriTime,
    DateTime? iftarTime,
    Duration? remainingTime,
    bool? isSehriCountdown,
  }) {
    return RamadanState(
      sehriTime: sehriTime ?? this.sehriTime,
      iftarTime: iftarTime ?? this.iftarTime,
      remainingTime: remainingTime ?? this.remainingTime,
      isSehriCountdown: isSehriCountdown ?? this.isSehriCountdown,
    );
  }

  @override
  List<Object?> get props => [sehriTime, iftarTime, remainingTime, isSehriCountdown];
}