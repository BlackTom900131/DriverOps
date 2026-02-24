import 'package:flutter/material.dart';
import '../state/offline_queue_state.dart';

/// Screen showing items queued for sync when offline.
class OfflineQueueScreen extends StatefulWidget {
  const OfflineQueueScreen({super.key});

  @override
  State<OfflineQueueScreen> createState() => _OfflineQueueScreenState();
}

class _OfflineQueueScreenState extends State<OfflineQueueScreen> {
  List<QueuedItem> _items = [];
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() {
    // TODO: Load from offline_queue_provider
    setState(() {
      _items = [];
    });
  }

  Future<void> _syncNow() async {
    if (_items.isEmpty) return;
    setState(() => _isSyncing = true);
    // TODO: Trigger sync via offline_queue_provider
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() {
        _isSyncing = false;
        _loadItems();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline queue'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          if (_items.isNotEmpty && !_isSyncing)
            TextButton(
              onPressed: _syncNow,
              child: const Text('Sync now'),
            ),
        ],
      ),
      body: _isSyncing
          ? const Center(child: CircularProgressIndicator())
          : _items.isEmpty
              ? const Center(child: Text('No items in queue'))
              : RefreshIndicator(
                  onRefresh: () async => _loadItems(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _items.length,
                    itemBuilder: (context, index) {
                      final item = _items[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Icon(
                            _iconForStatus(item.status),
                            color: _colorForStatus(context, item.status),
                          ),
                          title: Text(_labelForActionType(item.actionType)),
                          subtitle: Text(
                            _statusLabel(item.status) +
                                (item.lastError != null
                                    ? '\n${item.lastError}'
                                    : ''),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          isThreeLine: item.lastError != null,
                        ),
                      );
                    },
                  ),
                ),
    );
  }

  IconData _iconForStatus(QueuedItemStatus status) {
    switch (status) {
      case QueuedItemStatus.pending:
        return Icons.schedule;
      case QueuedItemStatus.syncing:
        return Icons.sync;
      case QueuedItemStatus.failed:
        return Icons.error_outline;
    }
  }

  Color _colorForStatus(BuildContext context, QueuedItemStatus status) {
    switch (status) {
      case QueuedItemStatus.pending:
        return Theme.of(context).colorScheme.primary;
      case QueuedItemStatus.syncing:
        return Theme.of(context).colorScheme.tertiary;
      case QueuedItemStatus.failed:
        return Theme.of(context).colorScheme.error;
    }
  }

  String _statusLabel(QueuedItemStatus status) {
    switch (status) {
      case QueuedItemStatus.pending:
        return 'Pending';
      case QueuedItemStatus.syncing:
        return 'Syncing…';
      case QueuedItemStatus.failed:
        return 'Failed';
    }
  }

  String _labelForActionType(QueuedActionType type) {
    switch (type) {
      case QueuedActionType.delivery:
        return 'Delivery';
      case QueuedActionType.pickup:
        return 'Pickup';
      case QueuedActionType.pod:
        return 'Proof of delivery';
      case QueuedActionType.workday:
        return 'Workday';
      case QueuedActionType.other:
        return 'Other';
    }
  }
}
