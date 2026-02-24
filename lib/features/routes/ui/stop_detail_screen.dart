import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/app_scaffold.dart';

class StopDetailScreen extends StatelessWidget {
  final String routeId;
  final String stopId;

  const StopDetailScreen({super.key, required this.routeId, required this.stopId});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Stop $stopId',
      body: ListView(
        children: [
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Route: $routeId', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 6),
                Text('Stop: $stopId'),
                const SizedBox(height: 12),
                const Text('Stop actions (UI):'),
                const SizedBox(height: 12),
                Wrap(spacing: 10, runSpacing: 10, children: [
                  FilledButton.icon(
                    onPressed: () => context.go('/home/routes/$routeId/stops/$stopId/pickup'),
                    icon: const Icon(Icons.qr_code_scanner),
                    label: const Text('Pickup'),
                  ),
                  FilledButton.icon(
                    onPressed: () => context.go('/home/routes/$routeId/stops/$stopId/delivery'),
                    icon: const Icon(Icons.local_shipping_outlined),
                    label: const Text('Delivery'),
                  ),
                ]),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Skipping stop'),
                      content: const Text('Skipping is restricted. Provide justification (UI placeholder).'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                        FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Submit')),
                      ],
                    ),
                  ),
                  child: const Text('Attempt to skip stop (shows restriction)'),
                ),
              ]),
            ),
          ),
          
        ],

      ),
    );
  }
}

