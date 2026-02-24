import 'package:flutter/material.dart';
import '../../../shared/widgets/app_scaffold.dart';

class FailedDeliveryScreen extends StatefulWidget {
  final String routeId;
  final String stopId;

  const FailedDeliveryScreen({super.key, required this.routeId, required this.stopId});

  @override
  State<FailedDeliveryScreen> createState() => _FailedDeliveryScreenState();
}

class _FailedDeliveryScreenState extends State<FailedDeliveryScreen> {
  String reason = 'Customer not available';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Failed Delivery',
      body: ListView(
        children: [
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Route: ${widget.routeId} • Stop: ${widget.stopId}'),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: reason,
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
                const TextField(
                  maxLines: 3,
                  decoration: InputDecoration(labelText: 'Note (required for "Other")'),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.photo_camera_outlined),
                      label: const Text('Add photo'),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Evidence required by config (UI)',
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Incident/ticket created (mock)')),
                    ),
                    child: const Text('Submit failure'),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

