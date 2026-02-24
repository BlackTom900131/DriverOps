import 'package:flutter/material.dart';
import '../state/routes_state.dart';

/// Detail for a single stop on a route.
class StopDetailScreen extends StatelessWidget {
  const StopDetailScreen({
    super.key,
    required this.route,
    required this.stop,
  });

  final RouteRecord route;
  final RouteStop stop;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(stop.name),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _DetailRow(label: 'Route', value: route.name),
                  _DetailRow(label: 'Stop', value: '${stop.sequenceIndex + 1}'),
                  _DetailRow(label: 'Name', value: stop.name),
                  if (stop.address != null && stop.address!.isNotEmpty)
                    _DetailRow(label: 'Address', value: stop.address!),
                  if (stop.arrivedAt != null)
                    _DetailRow(
                      label: 'Arrived',
                      value: _formatDateTime(stop.arrivedAt!),
                    ),
                  if (stop.completedAt != null)
                    _DetailRow(
                      label: 'Completed',
                      value: _formatDateTime(stop.completedAt!),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime d) {
    return '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')} '
        '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
