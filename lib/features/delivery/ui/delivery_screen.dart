import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
      title: tr('delivery.title', namedArgs: {'stopId': widget.stopId}),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.qr_code_scanner_outlined),
              title: Text(tr('delivery.pre_scan_required_title')),
              subtitle: Text(
                preDeliveryScanDone
                    ? tr('delivery.pre_scan_done')
                    : tr('delivery.pre_scan_needed'),
              ),
              trailing: FilledButton(
                onPressed: () => setState(() => preDeliveryScanDone = true),
                child: Text(
                  preDeliveryScanDone
                      ? tr('delivery.scanned')
                      : tr('delivery.scan_now'),
                ),
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
                    tr('delivery.status_section_title'),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 10),
                  SegmentedButton<DeliveryDecision>(
                    segments: [
                      ButtonSegment(
                        value: DeliveryDecision.delivered,
                        icon: const Icon(Icons.check_circle_outline),
                        label: Text(tr('delivery.delivered')),
                      ),
                      ButtonSegment(
                        value: DeliveryDecision.failed,
                        icon: const Icon(Icons.error_outline),
                        label: Text(tr('delivery.failed')),
                      ),
                    ],
                    selected: {decision},
                    onSelectionChanged: (selection) {
                      setState(() => decision = selection.first);
                    },
                  ),
                  const SizedBox(height: 12),
                  Text(
                    tr('delivery.supervisor_note'),
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
                      child: Text(tr('common.continue')),
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
