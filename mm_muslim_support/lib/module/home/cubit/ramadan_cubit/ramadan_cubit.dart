import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mm_muslim_support/service/get_prayer_time_service.dart';

part 'ramadan_state.dart';

class RamadanCubit extends Cubit<RamadanState> {
  Timer? _timer;

  RamadanCubit() : super(RamadanState.initial()) {
    _initPrayerTimes();
  }

  /// Initialize Sehri (Fajr) and Iftar (Maghrib) from PrayerTimes
  Future<void> _initPrayerTimes() async {
    final now = DateTime.now();
    final prayerTimes = GetPrayerTimeService.getPrayerTimes(dateTime: now);

    final sehriTime = prayerTimes.fajrStartTime;
    final iftarTime = prayerTimes.maghribStartTime;

    emit(state.copyWith(
      sehriTime: sehriTime,
      iftarTime: iftarTime,
    ));

    _startCountdown(sehriTime!, iftarTime!);
  }

  void _startCountdown(DateTime sehriTime, DateTime iftarTime) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();

      // Determine the next event
      final nextEvent = now.isBefore(sehriTime) ? sehriTime : iftarTime;
      final remaining = nextEvent.difference(now);

      emit(state.copyWith(
        remainingTime: remaining.isNegative ? Duration.zero : remaining,
        isSehriCountdown: now.isBefore(sehriTime),
      ));
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
