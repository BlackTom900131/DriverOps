import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/models/route_models.dart';
import '../state/routes_state.dart';
import '../../../shared/widgets/app_scaffold.dart';

class RoutesListScreen extends ConsumerWidget {
  const RoutesListScreen({super.key});
  static const MethodChannel _navigationChannel = MethodChannel(
    'driversystem/navigation',
  );

  String _typeLabel(RouteType type) {
    return switch (type) {
      RouteType.pickup => 'Pickup',
      RouteType.delivery => 'Delivery',
      RouteType.mixed => 'Mixed',
    };
  }

  String _statusLabel(RouteStatus status) {
    return switch (status) {
      RouteStatus.pending => 'Pending',
      RouteStatus.inProgress => 'In Progress',
      RouteStatus.completed => 'Completed',
    };
  }

  String _mapPoint(RouteStop stop) {
    if (stop.latitude != null && stop.longitude != null) {
      return '${stop.latitude},${stop.longitude}';
    }
    return stop.address;
  }

  Uri _mapsWebUriForRoute(DriverRoute route) {
    if (route.stops.isEmpty) {
      return Uri.parse('https://www.google.com/maps');
    }

    if (route.stops.length == 1) {
      final destination = Uri.encodeComponent(_mapPoint(route.stops.first));
      return Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$destination',
      );
    }

    final origin = Uri.encodeComponent(_mapPoint(route.stops.first));
    final destination = Uri.encodeComponent(_mapPoint(route.stops.last));
    final waypoints = route.stops
        .sublist(1, route.stops.length - 1)
        .map(_mapPoint)
        .join('|');
    final encodedWaypoints = Uri.encodeComponent(waypoints);
    final hasWaypoints = waypoints.trim().isNotEmpty;

    final url = hasWaypoints
        ? 'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=driving&waypoints=$encodedWaypoints'
        : 'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=driving';
    return Uri.parse(url);
  }

  Future<void> _openGoogleMapsWeb(
    BuildContext context,
    DriverRoute selectedRoute,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final opened = await _navigationChannel.invokeMethod<bool>(
        'openExternalUrl',
        {'url': _mapsWebUriForRoute(selectedRoute).toString()},
      );
      if (opened == true) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Unable to open Google Maps web.')),
      );
    } on PlatformException {
      messenger.showSnackBar(
        const SnackBar(content: Text('Unable to open Google Maps web.')),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final state = ref.watch(routesProvider);
    final routes = state.routes;
    final selectedRouteId = state.selectedRouteId;
    final selectedRoute = selectedRouteId == null
        ? null
        : routes.where((r) => r.id == selectedRouteId).firstOrNull;

    return AppScaffold(
      title: 'Assigned Routes',
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const SizedBox(height: 10),
          Card(
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: LinearGradient(
                  colors: [
                    colors.primary.withValues(alpha: 0.14),
                    colors.secondary.withValues(alpha: 0.08),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.alt_route_rounded, color: colors.primary),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Route Assignment',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Select a RouterID to view route details and continue.',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colors.onSurface.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Router Selectable List',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedRouteId,
                    decoration: const InputDecoration(
                      labelText: 'RouterID',
                      border: OutlineInputBorder(),
                    ),
                    items: routes
                        .map(
                          (r) => DropdownMenuItem<String>(
                            value: r.id,
                            child: Text(r.id),
                          ),
                        )
                        .toList(),
                    onChanged: (value) =>
                        ref.read(routesProvider.notifier).selectRoute(value),
                  ),
                  const SizedBox(height: 12),
                  if (selectedRoute != null)
                    GridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                      childAspectRatio: 2.4,
                      children: [
                        _InfoCell(
                          title: 'Route ID',
                          value: selectedRoute.id,
                          icon: Icons.tag_rounded,
                        ),
                        _InfoCell(
                          title: 'Route type',
                          value: _typeLabel(selectedRoute.type),
                          icon: Icons.category_outlined,
                        ),
                        _InfoCell(
                          title: 'Total stops',
                          value: selectedRoute.stops.length.toString(),
                          icon: Icons.pin_drop_outlined,
                        ),
                        _InfoCell(
                          title: 'Route status',
                          value: _statusLabel(selectedRoute.status),
                          icon: Icons.flag_outlined,
                        ),
                      ],
                    ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: selectedRouteId == null
                          ? null
                          : () => context.go('/home/routes/$selectedRouteId'),
                      icon: const Icon(Icons.chevron_right),
                      label: const Text('View Detail'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: selectedRoute == null
                          ? null
                          : () => _openGoogleMapsWeb(context, selectedRoute),
                      icon: const Icon(Icons.map_outlined),
                      label: const Text('View on Map'),
                    ),
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

class _InfoCell extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoCell({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: colors.outline.withValues(alpha: 0.45)),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white.withValues(alpha: 0.75),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 14, color: colors.primary),
              const SizedBox(width: 6),
              Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colors.onSurface.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            value,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
