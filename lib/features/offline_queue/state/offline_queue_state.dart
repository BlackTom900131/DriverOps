import 'package:flutter_riverpod/flutter_riverpod.dart';

class OfflineQueueState {
  final bool isOffline;
  final int pendingEvents;

  const OfflineQueueState({required this.isOffline, required this.pendingEvents});

  OfflineQueueState copyWith({bool? isOffline, int? pendingEvents}) {
    return OfflineQueueState(
      isOffline: isOffline ?? this.isOffline,
      pendingEvents: pendingEvents ?? this.pendingEvents,
    );
  }
}

class OfflineQueueNotifier extends StateNotifier<OfflineQueueState> {
  OfflineQueueNotifier() : super(const OfflineQueueState(isOffline: false, pendingEvents: 0));

  void toggleOffline() => state = state.copyWith(isOffline: !state.isOffline);

  void addMockEvent() => state = state.copyWith(pendingEvents: state.pendingEvents + 1);

  void clear() => state = state.copyWith(pendingEvents: 0);
}

final offlineQueueProvider = StateNotifierProvider<OfflineQueueNotifier, OfflineQueueState>((ref) {
  return OfflineQueueNotifier();
});
