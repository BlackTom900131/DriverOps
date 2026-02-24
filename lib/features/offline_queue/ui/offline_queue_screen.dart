import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../state/offline_queue_state.dart';

class OfflineQueueScreen extends ConsumerWidget {
  const OfflineQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(offlineQueueProvider);

    return AppScaffold(
      title: 'Offline Queue',
      body: ListView(
        children: [
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: Text('Mode: ${state.isOffline ? "OFFLINE" : "ONLINE (mock)"}'),
              subtitle: Text('Pending events: ${state.pendingEvents}'),
              trailing: FilledButton(
                onPressed: () => ref.read(offlineQueueProvider.notifier).toggleOffline(),
                child: Text(state.isOffline ? 'Go Online' : 'Go Offline'),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Add mock queued event'),
              onTap: () => ref.read(offlineQueueProvider.notifier).addMockEvent(),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Clear local queue (confirm in real app)'),
              onTap: () => ref.read(offlineQueueProvider.notifier).clear(),
            ),
          ),
        ],
      ),
    );
  }
}