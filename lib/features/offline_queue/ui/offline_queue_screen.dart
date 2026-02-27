import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
      title: tr('offline_queue.title'),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(
                state.isOffline ? Icons.cloud_off_outlined : Icons.cloud_done_outlined,
              ),
              title: Text(
                state.isOffline
                    ? tr('offline_queue.mode_offline')
                    : tr('offline_queue.mode_online'),
              ),
              subtitle: Text(
                tr('offline_queue.pending_events', namedArgs: {
                  'count': state.pendingEvents.toString(),
                }),
              ),
              trailing: FilledButton(
                onPressed: notifier.toggleOffline,
                child: Text(
                  state.isOffline
                      ? tr('offline_queue.connect')
                      : tr('offline_queue.disconnect'),
                ),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.sync_outlined),
              title: Text(tr('offline_queue.sync_now')),
              subtitle: Text(tr('offline_queue.sync_subtitle')),
              onTap: state.isOffline || state.pendingEvents == 0
                  ? null
                  : () {
                      notifier.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(tr('offline_queue.synced_mock')),
                        ),
                      );
                    },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.add),
              title: Text(tr('offline_queue.add_mock_event')),
              onTap: notifier.addMockEvent,
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_outline),
              title: Text(tr('offline_queue.clear_local_queue')),
              onTap: notifier.clear,
            ),
          ),
        ],
      ),
    );
  }
}
