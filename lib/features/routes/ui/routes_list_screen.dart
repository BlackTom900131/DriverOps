import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../state/routes_state.dart';
import '../../../shared/models/route_models.dart';
import '../../../shared/widgets/app_scaffold.dart';

class RoutesListScreen extends ConsumerWidget {
  const RoutesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final routes = ref.watch(routesProvider).routes;

    return AppScaffold(
      title: 'Routes',
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ...routes.map((r) => Card(
                child: ListTile(
                  title: Text(r.id),
                  subtitle: Text('${r.type.name} • ${r.stops.length} stops • ${r.status.name}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/home/routes/${r.id}'),
                ),
              )),
        ],
      ),
    );
  }
}