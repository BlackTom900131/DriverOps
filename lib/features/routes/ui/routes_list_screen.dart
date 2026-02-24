import 'package:flutter/material.dart';
import 'route_detail_screen.dart';
import '../state/routes_state.dart';

/// List of routes; tap a route to open its detail.
class RoutesListScreen extends StatefulWidget {
  const RoutesListScreen({super.key});

  @override
  State<RoutesListScreen> createState() => _RoutesListScreenState();
}

class _RoutesListScreenState extends State<RoutesListScreen> {
  List<RouteRecord> _routes = [];

  @override
  void initState() {
    super.initState();
    _loadRoutes();
  }

  void _loadRoutes() {
    // TODO: Load from routes_provider
    setState(() {
      _routes = [
        RouteRecord(
          id: '1',
          name: 'Downtown delivery',
          origin: 'Warehouse A',
          destination: 'Downtown',
          status: RouteStatus.planned,
          scheduledAt: DateTime.now(),
          stops: [
            const RouteStop(id: 's1', name: 'Stop 1', address: '123 Main St', sequenceIndex: 0),
            const RouteStop(id: 's2', name: 'Stop 2', address: '456 Oak Ave', sequenceIndex: 1),
          ],
        ),
        RouteRecord(
          id: '2',
          name: 'North route',
          origin: 'Depot',
          destination: 'North District',
          status: RouteStatus.inProgress,
          scheduledAt: DateTime.now().subtract(const Duration(hours: 2)),
          stops: const [],
        ),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Routes'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: _routes.isEmpty
          ? const Center(child: Text('No routes'))
          : RefreshIndicator(
              onRefresh: () async => _loadRoutes(),
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _routes.length,
                itemBuilder: (context, index) {
                  final route = _routes[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: ListTile(
                      title: Text(route.name),
                      subtitle: Text(
                        '${route.origin ?? '—'} → ${route.destination ?? '—'}\n${_statusLabel(route.status)}',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _openRouteDetail(route),
                    ),
                  );
                },
              ),
            ),
    );
  }

  Future<void> _openRouteDetail(RouteRecord route) async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => RouteDetailScreen(route: route),
      ),
    );
  }

  String _statusLabel(RouteStatus status) {
    switch (status) {
      case RouteStatus.planned:
        return 'Planned';
      case RouteStatus.inProgress:
        return 'In progress';
      case RouteStatus.completed:
        return 'Completed';
      case RouteStatus.cancelled:
        return 'Cancelled';
    }
  }
}
