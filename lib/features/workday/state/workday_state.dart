import 'package:flutter_riverpod/flutter_riverpod.dart';

class WorkdayState {
  final bool started;
  final DateTime? startedAt;

  const WorkdayState({required this.started, this.startedAt});

  WorkdayState copyWith({bool? started, DateTime? startedAt}) {
    return WorkdayState(
      started: started ?? this.started,
      startedAt: startedAt ?? this.startedAt,
    );
  }
}

class WorkdayNotifier extends StateNotifier<WorkdayState> {
  WorkdayNotifier() : super(const WorkdayState(started: false));

  void start() => state = state.copyWith(started: true, startedAt: DateTime.now());
  void reset() => state = const WorkdayState(started: false);
}

final workdayProvider = StateNotifierProvider<WorkdayNotifier, WorkdayState>((ref) {
  return WorkdayNotifier();
});
