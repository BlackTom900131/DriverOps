import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/navigation/app_routes.dart';
import '../../../shared/models/route_models.dart';
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

  String _stopTypeLabel(StopType? type) {
    return switch (type) {
      StopType.pickup => 'Recogida',
      StopType.delivery => 'Entrega',
      StopType.mixed => 'Mixta',
      null => '-',
    };
  }

  String _stopStatusLabel(StopStatus? status, StopType? type) {
    if (status == null) return '-';
    if (status == StopStatus.done && type == StopType.pickup) {
      return 'RECOGIDO';
    }
    return switch (status) {
      StopStatus.pending => 'PENDIENTE',
      StopStatus.inProgress => 'EN PROGRESO',
      StopStatus.done => 'COMPLETADO',
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(routesProvider.notifier);
    final colors = Theme.of(context).colorScheme;
    final blockedReason = notifier.firstBlockedStopReason(routeId, stopId);
    final isBlocked = blockedReason != null;
    final route = notifier.byId(routeId);
    final stopIndex = route?.stops.indexWhere((s) => s.id == stopId) ?? -1;
    final stop = stopIndex >= 0 ? route!.stops[stopIndex] : null;
    final totalStops = route?.stops.length ?? 0;
    final stopPosition = stopIndex >= 0 ? stopIndex + 1 : null;

    return AppScaffold(
      title: 'Verificar parada',
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _RouteHeader(routeId: routeId),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            colors.primary,
                            colors.primary.withValues(alpha: 0.82),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: colors.primary.withValues(alpha: 0.24),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        'Parada ${stopPosition ?? '-'}',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.2,
                            ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Detalles de la posición de la parada',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: colors.primary.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colors.primary.withValues(alpha: 0.22),
                        ),
                      ),
                      child: Column(
                        children: [
                          _InfoRow(
                            label: 'Posición',
                            value: '${stopPosition ?? '-'} / $totalStops',
                          ),
                          const SizedBox(height: 8),
                          _InfoRow(label: 'ID de parada', value: stopId),
                          const SizedBox(height: 8),
                          _InfoRow(
                            label: 'Cliente',
                            value: stop?.customerName ?? '-',
                          ),
                          const SizedBox(height: 8),
                          _InfoRow(
                            label: 'Dirección',
                            value: stop?.address ?? '-',
                          ),
                          const SizedBox(height: 8),
                          _InfoRow(
                            label: 'Contacto',
                            value: stop?.customerContact ?? '-',
                          ),
                          const SizedBox(height: 8),
                          _InfoRow(
                            label: 'Paquetes esp.',
                            value: stop == null
                                ? '-'
                                : stop.expectedPackages.toString(),
                          ),
                          const SizedBox(height: 8),
                          _InfoRow(
                            label: 'Tipo',
                            value: _stopTypeLabel(stop?.type),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 80,
                                child: Text(
                                  'Estado',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: colors.primary,
                                      ),
                                ),
                              ),
                              const Text(':  '),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: colors.primary.withValues(alpha: 0.14),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  _stopStatusLabel(stop?.status, stop?.type),
                                  style: Theme.of(context).textTheme.labelSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: colors.primary,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
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
                        'Seleccione una acción abajo para verificar esta parada.',
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: isBlocked
                            ? null
                            : () => context.push(
                                AppRoutes.stopPickup(routeId, stopId),
                              ),
                        icon: const Icon(Icons.qr_code_scanner),
                        label: const Text('Recogida'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: isBlocked
                            ? null
                            : () => context.push(
                                AppRoutes.stopDelivery(routeId, stopId),
                              ),
                        icon: const Icon(Icons.local_shipping_outlined),
                        label: const Text('Entrega'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text('Omitir parada'),
                            content: const Text(
                              'Omitir está restringido. Se requiere justificación del supervisor.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Cancelar'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(context),
                                child: const Text('Enviar solicitud'),
                              ),
                            ],
                          ),
                        ),
                        icon: const Icon(Icons.assignment_outlined),
                        label: const Text('Solicitar justificación de omisión'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: colors.primary,
            ),
          ),
        ),
        const Text(':  '),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: colors.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}

class _RouteHeader extends StatelessWidget {
  final String routeId;

  const _RouteHeader({required this.routeId});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: const Color(0xFF0F2A4A),
        border: Border.all(
          color: const Color(0xFF12B3A8).withValues(alpha: 0.45),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        'ID de ruta: $routeId',
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          fontWeight: FontWeight.w800,
          color: Colors.white,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}
