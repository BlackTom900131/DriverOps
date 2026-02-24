import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../state/routes_state.dart';
import '../../../shared/widgets/app_scaffold.dart';

class StopDetailScreen extends ConsumerWidget {
  final String routeId;
  final String stopId;

  const StopDetailScreen({
    super.key,
    required this.routeId,
    required this.stopId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(routesProvider.notifier);
    final blockedReason = notifier.firstBlockedStopReason(routeId, stopId);
    final isBlocked = blockedReason != null;

    return AppScaffold(
      title: 'Stop $stopId',
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Route: $routeId',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text('Stop: $stopId'),
                  const SizedBox(height: 12),
                  if (isBlocked)
                    Text(
                      blockedReason,
                      style: const TextStyle(
                        color: Color(0xFFC62828),
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  else
                    const Text(
                      'Stop actions',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      FilledButton.icon(
                        onPressed: isBlocked
                            ? null
                            : () => context.go(
                                  '/home/routes/$routeId/stops/$stopId/pickup',
                                ),
                        icon: const Icon(Icons.qr_code_scanner),
                        label: const Text('Pickup'),
                      ),
                      FilledButton.icon(
                        onPressed: isBlocked
                            ? null
                            : () => context.go(
                                  '/home/routes/$routeId/stops/$stopId/delivery',
                                ),
                        icon: const Icon(Icons.local_shipping_outlined),
                        label: const Text('Delivery'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => showDialog(
                      context: context,
                      builder: (_) => AlertDialog(
                        title: const Text('Skipping stop'),
                        content: const Text(
                          'Skipping is restricted. A supervisor justification is required.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel'),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Submit request'),
                          ),
                        ],
                      ),
                    ),
                    child: const Text('Request skip justification'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
