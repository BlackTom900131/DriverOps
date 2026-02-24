import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../state/offline_queue_state.dart';

class OfflineQueueScreen extends ConsumerWidget {
  const OfflineQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(offlineQueueProvider);
    final notifier = ref.read(offlineQueueProvider.notifier);

    return AppScaffold(
      title: 'Offline Queue',
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(
                state.isOffline ? Icons.cloud_off_outlined : Icons.cloud_done_outlined,
              ),
              title: Text(state.isOffline ? 'Mode: OFFLINE' : 'Mode: ONLINE'),
              subtitle: Text('Pending events: ${state.pendingEvents}'),
              trailing: FilledButton(
                onPressed: notifier.toggleOffline,
                child: Text(state.isOffline ? 'Go Online' : 'Go Offline'),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.sync_outlined),
              title: const Text('Sync queue now'),
              subtitle: const Text('Retries and conflict handling are backend-driven.'),
              onTap: state.isOffline || state.pendingEvents == 0
                  ? null
                  : () {
                      notifier.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Queue synced successfully (mock).')),
                      );
                    },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add mock queued event'),
              onTap: notifier.addMockEvent,
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Clear local queue'),
              onTap: notifier.clear,
            ),
          ),
        ],
      ),
    );
  }
}
