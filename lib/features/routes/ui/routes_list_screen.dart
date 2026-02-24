import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../state/routes_state.dart';
import '../../../shared/widgets/app_scaffold.dart';

class RoutesListScreen extends ConsumerWidget {
  const RoutesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(routesProvider).routes;
    final totalStops = routes.fold<int>(0, (sum, r) => sum + r.stops.length);

    return AppScaffold(
      title: 'Assigned Routes',
      body: ListView(
        padding: const EdgeInsets.only(bottom: 18),
        children: [
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.alt_route_outlined),
              title: const Text('Today Workload'),
              subtitle: Text('${routes.length} route(s) | $totalStops stop(s)'),
            ),
          ),
          ...routes.map(
            (r) => Card(
              child: ListTile(
                title: Text(r.id),
                subtitle: Text(
                  '${r.type.name} | ${r.stops.length} stops | ${r.status.name}',
                ),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => context.go('/home/routes/${r.id}'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
