import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../offline_queue/state/offline_queue_state.dart';

class PickupScreen extends ConsumerStatefulWidget {
  final String routeId;
  final String stopId;

  const PickupScreen({super.key, required this.routeId, required this.stopId});

  @override
  ConsumerState<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends ConsumerState<PickupScreen> {
  int scanned = 0;
  final expected = 5;

  @override
  Widget build(BuildContext context) {
    final queue = ref.watch(offlineQueueProvider);
    final done = scanned >= expected;
    return AppScaffold(
      title: 'Pickup - ${widget.stopId}',
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: const Text('Pickup point'),
              subtitle: Text(
                'Route: ${widget.routeId}\nStop: ${widget.stopId}\nExpected packages: $expected',
              ),
              isThreeLine: true,
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: Text('Scanned packages: $scanned / $expected'),
              subtitle: Text(
                queue.isOffline
                    ? 'Offline mode: scans are queued locally.'
                    : 'Online mode: scans are synced immediately (mock).',
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('Scan package'),
              subtitle: const Text(
                'Duplicate and mismatch checks are required in production.',
              ),
              trailing: FilledButton(
                onPressed: done
                    ? null
                    : () {
                        setState(() => scanned += 1);
                        ref.read(offlineQueueProvider.notifier).addMockEvent();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Scan recorded and logged.')),
                        );
                      },
                child: const Text('Scan'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton(
              onPressed: !done
                  ? null
                  : () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Pickup confirmed (mock).')),
                      ),
              child: const Text('Confirm load reception'),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: OutlinedButton(
              onPressed: () {},
              child: const Text('Manual entry with supervisor authorization'),
            ),
          ),
        ],
      ),
    );
  }
}
