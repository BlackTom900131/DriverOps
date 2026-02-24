import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../state/routes_state.dart';
import '../../../shared/widgets/app_scaffold.dart';

class RouteDetailScreen extends ConsumerWidget {
  final String routeId;
  const RouteDetailScreen({super.key, required this.routeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(routesProvider.notifier);
    final routes = ref.watch(routesProvider).routes;
    final route = routes.firstWhere((r) => r.id == routeId);

    return AppScaffold(
      title: 'Route $routeId',
      body: ListView(
        padding: const EdgeInsets.only(bottom: 18),
        children: [
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: Text('Route $routeId'),
              subtitle: Text(
                '${route.type.name} | ${route.status.name} | ${route.stops.length} stops',
              ),
            ),
          ),
          ...route.stops.map((s) {
            final blockedReason = notifier.firstBlockedStopReason(routeId, s.id);
            final isBlocked = blockedReason != null;
            return Card(
              child: ListTile(
                title: Text('${s.id} - ${s.customerName}'),
                subtitle: Text(
                  isBlocked
                      ? '${s.address}\n$blockedReason'
                      : '${s.address}\nStatus: ${s.status.name}',
                ),
                isThreeLine: true,
                trailing: Icon(
                  isBlocked ? Icons.lock_outline : Icons.chevron_right,
                ),
                onTap: () {
                  if (isBlocked) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(blockedReason)),
                    );
                    return;
                  }
                  context.go('/home/routes/$routeId/stops/${s.id}');
                },
              ),
            );
          }),
        ],
      ),
    );
  }
}
