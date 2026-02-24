import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/widgets/app_scaffold.dart';

class DeliveryScreen extends StatefulWidget {
  final String routeId;
  final String stopId;

  const DeliveryScreen({super.key, required this.routeId, required this.stopId});

  @override
  State<DeliveryScreen> createState() => _DeliveryScreenState();
}

class _DeliveryScreenState extends State<DeliveryScreen> {
  String status = 'Delivered';

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Delivery — ${widget.stopId}',
      body: ListView(
        children: [
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: const Text('Pre-delivery scan (UI placeholder)'),
              subtitle: const Text('Must scan package before marking delivered/failed.'),
              trailing: OutlinedButton(onPressed: () {}, child: const Text('Scan')),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('Delivery Status (UI)'),
                const SizedBox(height: 10),
                RadioListTile(
                  value: 'Delivered',
                  groupValue: status,
                  onChanged: (v) => setState(() => status = v.toString()),
                  title: const Text('Delivered'),
                ),
                RadioListTile(
                  value: 'Failed',
                  groupValue: status,
                  onChanged: (v) => setState(() => status = v.toString()),
                  title: const Text('Failed'),
                ),
                const SizedBox(height: 12),
                Text(
                  'Note: Status cannot be edited without supervisor authorization (UI reminder).',
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      if (status == 'Delivered') {
                        context.go('/home/routes/${widget.routeId}/stops/${widget.stopId}/delivery/pod');
                      } else {
                        context.go('/home/routes/${widget.routeId}/stops/${widget.stopId}/delivery/failed');
                      }
                    },
                    child: const Text('Continue'),
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
