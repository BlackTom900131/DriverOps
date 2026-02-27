import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../shared/widgets/app_scaffold.dart';

enum FailureReason {
  customerUnavailable,
  wrongAddress,
  customerRejected,
  otherNeedsNote,
}

class FailedDeliveryScreen extends StatefulWidget {
  final String routeId;
  final String stopId;

  const FailedDeliveryScreen({
    super.key,
    required this.routeId,
    required this.stopId,
  });

  @override
  State<FailedDeliveryScreen> createState() => _FailedDeliveryScreenState();
}

class _FailedDeliveryScreenState extends State<FailedDeliveryScreen> {
  FailureReason reason = FailureReason.customerUnavailable;
  final noteController = TextEditingController();
  bool evidenceAdded = false;

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final needsNote = reason == FailureReason.otherNeedsNote;
    final canSubmit = !needsNote || noteController.text.trim().isNotEmpty;

    return AppScaffold(
      title: tr('failed_delivery.title'),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(
                      'failed_delivery.route_stop',
                      namedArgs: {
                        'routeId': widget.routeId,
                        'stopId': widget.stopId,
                      },
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<FailureReason>(
                    initialValue: reason,
                    items: [
                      DropdownMenuItem(
                        value: FailureReason.customerUnavailable,
                        child: Text(tr('failed_delivery.reason_customer_unavailable')),
                      ),
                      DropdownMenuItem(
                        value: FailureReason.wrongAddress,
                        child: Text(tr('failed_delivery.reason_wrong_address')),
                      ),
                      DropdownMenuItem(
                        value: FailureReason.customerRejected,
                        child: Text(tr('failed_delivery.reason_customer_rejected')),
                      ),
                      DropdownMenuItem(
                        value: FailureReason.otherNeedsNote,
                        child: Text(tr('failed_delivery.reason_other_needs_note')),
                      ),
                    ],
                    onChanged: (v) => setState(() => reason = v ?? reason),
                    decoration: InputDecoration(
                      labelText: tr('failed_delivery.reason_label'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: noteController,
                    onChanged: (_) => setState(() {}),
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: needsNote
                          ? tr('failed_delivery.note_required')
                          : tr('failed_delivery.note_optional'),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => setState(() => evidenceAdded = true),
                        icon: const Icon(Icons.photo_camera_outlined),
                        label: Text(
                          evidenceAdded
                              ? tr('failed_delivery.evidence_added')
                              : tr('failed_delivery.add_photo'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        tr('failed_delivery.evidence_policy'),
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: !canSubmit
                          ? null
                          : () => ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(tr('failed_delivery.submitted_mock')),
                                ),
                              ),
                      child: Text(tr('failed_delivery.submit_failure')),
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
