import 'package:flutter/material.dart';
import '../../../shared/widgets/app_scaffold.dart';

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
  String reason = 'Customer not available';
  final noteController = TextEditingController();
  bool evidenceAdded = false;

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final needsNote = reason == 'Other (requires note)';
    final canSubmit = !needsNote || noteController.text.trim().isNotEmpty;

    return AppScaffold(
      title: 'Failed Delivery',
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
                  Text('Route: ${widget.routeId} | Stop: ${widget.stopId}'),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: reason,
                    items: const [
                      'Customer not available',
                      'Incorrect address',
                      'Refused by customer',
                      'Other (requires note)',
                    ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (v) => setState(() => reason = v ?? reason),
                    decoration: const InputDecoration(labelText: 'Reason'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: noteController,
                    onChanged: (_) => setState(() {}),
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText: needsNote ? 'Note (required)' : 'Note (optional)',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => setState(() => evidenceAdded = true),
                        icon: const Icon(Icons.photo_camera_outlined),
                        label: Text(evidenceAdded ? 'Evidence added' : 'Add photo'),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Evidence policy configurable',
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
                                const SnackBar(
                                  content: Text('Failure submitted. Incident created via API.'),
                                ),
                              ),
                      child: const Text('Submit failure'),
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
