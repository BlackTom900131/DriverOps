import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/navigation/app_routes.dart';
import '../../../shared/extensions/iterable_extensions.dart';
import '../../../shared/models/route_models.dart';
import '../state/routes_state.dart';
import '../../../shared/widgets/app_scaffold.dart';

const _bluePrimary = Color(0xFF1565C0);
const _blueLight = Color(0xFFE3F2FD);
const _blueBorder = Color(0xFF90CAF9);

class RoutesListScreen extends ConsumerWidget {
  const RoutesListScreen({super.key});
  static const MethodChannel _navigationChannel = MethodChannel(
    'driversystem/navigation',
  );

  String _typeLabel(RouteType type) {
    return switch (type) {
      RouteType.pickup => 'Recogida',
      RouteType.delivery => 'Entrega',
      RouteType.mixed => 'Mixta',
    };
  }

  String _stopTypeLabel(StopType type) {
    return switch (type) {
      StopType.pickup => 'Recogida',
      StopType.delivery => 'Entrega',
      StopType.mixed => 'Mixta',
    };
  }

  String _stopStatusLabel(StopStatus status, StopType type) {
    if (status == StopStatus.done && type == StopType.pickup) {
      return 'Recogido';
    }
    return switch (status) {
      StopStatus.pending => 'Pendiente',
      StopStatus.inProgress => 'En progreso',
      StopStatus.done => 'Completado',
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
        const SnackBar(
          content: Text('No se puede abrir Google Maps en la web.'),
        ),
      );
    } on PlatformException {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('No se puede abrir Google Maps en la web.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(routesProvider);
    final routes = state.routes;
    final selectedRouteId = state.selectedRouteId;
    final selectedRoute = selectedRouteId == null
        ? null
        : routes.where((r) => r.id == selectedRouteId).firstOrNull;

    return AppScaffold(
      title: 'Rutas asignadas',
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const SizedBox(height: 10),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Lista seleccionable de rutas',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: selectedRouteId,
                    decoration: const InputDecoration(
                      labelText: 'ID de ruta',
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
                    _RouteSummaryStrip(
                      routeType: _typeLabel(selectedRoute.type),
                      totalStops: selectedRoute.stops.length.toString(),
                      routeStatus: selectedRoute.status,
                    ),
                  if (selectedRoute != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Lista de paradas',
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: selectedRoute.stops.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, index) {
                        final stop = selectedRoute.stops[index];
                        final stopType = _stopTypeLabel(stop.type);
                        final stopStatus = _stopStatusLabel(
                          stop.status,
                          stop.type,
                        );
                        return ListTile(
                          contentPadding: const EdgeInsets.fromLTRB(
                            12,
                            10,
                            12,
                            10,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                            side: BorderSide(
                              color: _blueBorder.withValues(alpha: 0.65),
                            ),
                          ),
                          tileColor: Colors.white,
                          leading: CircleAvatar(
                            backgroundColor: _bluePrimary.withValues(
                              alpha: 0.12,
                            ),
                            foregroundColor: _bluePrimary,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),
                          title: Text(
                            stop.customerName,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Wrap(
                                  spacing: 6,
                                  runSpacing: 6,
                                  children: [
                                    _StopChip(label: stopType),
                                    _StopChip(
                                      label: stopStatus,
                                      isStatus: true,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  stop.address,
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        color: const Color(0xFF3A4B61),
                                      ),
                                ),
                              ],
                            ),
                          ),
                          isThreeLine: true,
                          trailing: const Icon(
                            Icons.chevron_right,
                            color: _bluePrimary,
                          ),
                          onTap: () => context.push(
                            AppRoutes.stopDetails(selectedRoute.id, stop.id),
                          ),
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: selectedRoute == null
                          ? null
                          : () => _openGoogleMapsWeb(context, selectedRoute),
                      icon: const Icon(Icons.map_outlined),
                      label: const Text('Ver en el mapa'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: _bluePrimary,
                        side: const BorderSide(color: _bluePrimary),
                      ),
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

class _RouteSummaryStrip extends StatelessWidget {
  final String routeType;
  final String totalStops;
  final RouteStatus routeStatus;

  const _RouteSummaryStrip({
    required this.routeType,
    required this.totalStops,
    required this.routeStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [_blueLight, Color(0xFFBBDEFB)],
        ),
        border: Border.all(color: _blueBorder),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _bluePrimary.withValues(alpha: 0.16),
            blurRadius: 14,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _SummaryItem(title: 'Tipo de ruta', value: routeType),
          ),
          const _SummaryDivider(),
          Expanded(
            child: _SummaryItem(title: 'Paradas totales', value: totalStops),
          ),
          const _SummaryDivider(),
          Expanded(child: _StatusSummaryItem(status: routeStatus)),
        ],
      ),
    );
  }
}

class _SummaryDivider extends StatelessWidget {
  const _SummaryDivider();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      alignment: Alignment.center,
      child: Container(
        width: 2,
        height: 46,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(999),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withValues(alpha: 0.0),
              _bluePrimary.withValues(alpha: 0.25),
              _bluePrimary.withValues(alpha: 0.25),
              Colors.white.withValues(alpha: 0.0),
            ],
          ),
        ),
      ),
    );
  }
}

class _StopChip extends StatelessWidget {
  final String label;
  final bool isStatus;

  const _StopChip({required this.label, this.isStatus = false});

  @override
  Widget build(BuildContext context) {
    final background = isStatus
        ? _bluePrimary.withValues(alpha: 0.12)
        : _blueLight.withValues(alpha: 0.75);
    final foreground = isStatus ? _bluePrimary : const Color(0xFF24456E);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _blueBorder.withValues(alpha: 0.75)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: foreground,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String title;
  final String value;

  const _SummaryItem({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    return SizedBox(
      height: 58,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title.toUpperCase(),
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: colors.onSurface.withValues(alpha: 0.62),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
            ),
          ),
          Text(
            value,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w900,
              color: colors.onSurface,
              letterSpacing: 0.1,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusSummaryItem extends StatelessWidget {
  final RouteStatus status;

  const _StatusSummaryItem({required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final (background, foreground, border, label) = switch (status) {
      RouteStatus.pending => (
        const Color(0xFFFFF4DE),
        const Color(0xFF8A4B00),
        const Color(0xFFFFD08A),
        'Pendiente',
      ),
      RouteStatus.inProgress => (
        const Color(0xFFE3F2FD),
        const Color(0xFF0D47A1),
        const Color(0xFF90CAF9),
        'En progreso',
      ),
      RouteStatus.completed => (
        const Color(0xFFE7F7EC),
        const Color(0xFF1B5E20),
        const Color(0xFFA5D6A7),
        'Completado',
      ),
    };

    return SizedBox(
      height: 58,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'ESTADO DE RUTA',
            textAlign: TextAlign.center,
            style: theme.textTheme.labelSmall?.copyWith(
              color: const Color(0xFF4B5D75),
              fontWeight: FontWeight.w600,
              letterSpacing: 0.7,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: border),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: foreground,
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
