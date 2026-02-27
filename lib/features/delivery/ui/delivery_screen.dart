import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../app/navigation/app_routes.dart';
import '../../../shared/widgets/app_scaffold.dart';

enum DeliveryDecision { delivered, failed }

class DeliveryScreen extends StatefulWidget {
  final String routeId;
  final String stopId;

  const DeliveryScreen({super.key, required this.routeId, required this.stopId});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  DeliveryDecision decision = DeliveryDecision.delivered;
  bool preDeliveryScanDone = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Entrega - ${widget.stopId}',
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.qr_code_scanner_outlined),
              title: const Text('Escaneo previo a la entrega obligatorio'),
              subtitle: Text(
                preDeliveryScanDone
                    ? 'Escaneo completado. Puede continuar.'
                    : 'Debe escanear el código de barras/QR del paquete antes de seleccionar el estado.',
              ),
              trailing: FilledButton(
                onPressed: () => setState(() => preDeliveryScanDone = true),
                child: Text(preDeliveryScanDone ? 'Escaneado' : 'Escanear ahora'),
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Estado de la entrega',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  SegmentedButton<DeliveryDecision>(
                    segments: const [
                      ButtonSegment(
                        value: DeliveryDecision.delivered,
                        icon: Icon(Icons.check_circle_outline),
                        label: Text('Entregado'),
                      ),
                      ButtonSegment(
                        value: DeliveryDecision.failed,
                        icon: Icon(Icons.error_outline),
                        label: Text('Fallido'),
                      ),
                    ],
                    selected: {decision},
                    onSelectionChanged: (selection) {
                      setState(() => decision = selection.first);
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Los cambios de estado después del envío requieren autorización del supervisor.',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: !preDeliveryScanDone
                          ? null
                          : () {
                              if (decision == DeliveryDecision.delivered) {
                                context.go(
                                  AppRoutes.stopDeliveryPod(
                                    widget.routeId,
                                    widget.stopId,
                                  ),
                                );
                              } else {
                                context.go(
                                  AppRoutes.stopDeliveryFailed(
                                    widget.routeId,
                                    widget.stopId,
                                  ),
                                );
                              }
                            },
                      child: const Text('Continuar'),
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
