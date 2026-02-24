import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
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
      title: 'Delivery - ${widget.stopId}',
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.qr_code_scanner_outlined),
              title: const Text('Mandatory pre-delivery scan'),
              subtitle: Text(
                preDeliveryScanDone
                    ? 'Scan completed. You can proceed.'
                    : 'You must scan package barcode/QR before status selection.',
              ),
              trailing: FilledButton(
                onPressed: () => setState(() => preDeliveryScanDone = true),
                child: Text(preDeliveryScanDone ? 'Scanned' : 'Scan now'),
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
                    'Delivery status',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  SegmentedButton<DeliveryDecision>(
                    segments: const [
                      ButtonSegment(
                        value: DeliveryDecision.delivered,
                        icon: Icon(Icons.check_circle_outline),
                        label: Text('Delivered'),
                      ),
                      ButtonSegment(
                        value: DeliveryDecision.failed,
                        icon: Icon(Icons.error_outline),
                        label: Text('Failed'),
                      ),
                    ],
                    selected: {decision},
                    onSelectionChanged: (selection) {
                      setState(() => decision = selection.first);
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Status changes after submission require supervisor authorization.',
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
                                  '/home/routes/${widget.routeId}/stops/${widget.stopId}/delivery/pod',
                                );
                              } else {
                                context.go(
                                  '/home/routes/${widget.routeId}/stops/${widget.stopId}/delivery/failed',
                                );
                              }
                            },
                      child: const Text('Continue'),
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
