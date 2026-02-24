/// Status of a queued item (e.g. pending sync, syncing, failed).
enum QueuedItemStatus {
  pending,
  syncing,
  failed,
}

/// Type of action to sync when back online.
enum QueuedActionType {
  delivery,
  pickup,
  pod,
  workday,
  other,
}

/// A single item in the offline queue (action to sync).
class QueuedItem {
  const QueuedItem({
    required this.id,
    required this.actionType,
    required this.payload,
    this.status = QueuedItemStatus.pending,
    this.createdAt,
    this.lastError,
  });

  final String id;
  final QueuedActionType actionType;
  final Map<String, dynamic> payload;
  final QueuedItemStatus status;
  final DateTime? createdAt;
  final String? lastError;

  QueuedItem copyWith({
    String? id,
    QueuedActionType? actionType,
    Map<String, dynamic>? payload,
    QueuedItemStatus? status,
    DateTime? createdAt,
    String? lastError,
  }) {
    return QueuedItem(
      id: id ?? this.id,
      actionType: actionType ?? this.actionType,
      payload: payload ?? this.payload,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastError: lastError ?? this.lastError,
    );
  }
}

/// Holds the offline queue feature state.
class OfflineQueueState {
  const OfflineQueueState({
    this.items = const [],
    this.isSyncing = false,
    this.error,
  });

  final List<QueuedItem> items;
  final bool isSyncing;
  final String? error;

  OfflineQueueState copyWith({
    List<QueuedItem>? items,
    bool? isSyncing,
    String? error,
  }) {
    return OfflineQueueState(
      items: items ?? this.items,
      isSyncing: isSyncing ?? this.isSyncing,
      error: error,
    );
  }
}
