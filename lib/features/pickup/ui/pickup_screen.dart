import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../offline_queue/state/offline_queue_state.dart';

class PickupScreen extends ConsumerWidget {
  final String routeId;
  final String stopId;

  const PickupScreen({super.key, required this.routeId, required this.stopId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      title: 'Pickup — $stopId',
      body: ListView(
        children: [
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: const Text('Pickup Point Info (mock)'),
              subtitle: Text('Route: $routeId\nStop: $stopId\nExpected packages: 5'),
              isThreeLine: true,
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.qr_code_scanner),
              title: const Text('Scan package (UI only)'),
              subtitle: const Text('Barcode/QR scanning required (mock).'),
              trailing: FilledButton(
                onPressed: () {
                  // Add an offline queue mock event
                  ref.read(offlineQueueProvider.notifier).addMockEvent();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Scanned (mock) — queued event +1')),
                  );
                },
                child: const Text('Scan'),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Pickup stop closed (mock)')),
              ),
              child: const Text('Close pickup stop (requires confirmation in real app)'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
