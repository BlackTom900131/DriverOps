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
    final routes = ref.watch(routesProvider).routes;
    final route = routes.firstWhere((r) => r.id == routeId);

    return AppScaffold(
      title: 'Route $routeId',
      body: ListView(
        children: [
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: Text('Route $routeId'),
              subtitle: Text('${route.type.name} • ${route.status.name} • ${route.stops.length} stops'),
            ),
          ),
          ...route.stops.map((s) => Card(
                child: ListTile(
                  title: Text('${s.id} — ${s.customerName}'),
                  subtitle: Text('${s.address}\nStatus: ${s.status.name}'),
                  isThreeLine: true,
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/home/routes/$routeId/stops/${s.id}'),
                ),
              )),
        ],
      ),
    );
  }
  
}
