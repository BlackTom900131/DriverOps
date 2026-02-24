import 'package:flutter/material.dart';
import 'stop_detail_screen.dart';
import '../state/routes_state.dart';

/// Detail for a single route: info and list of stops.
class RouteDetailScreen extends StatelessWidget {
  const RouteDetailScreen({super.key, required this.route});

  final RouteRecord route;

  @override
  Widget build(BuildContext context) {
    final stops = route.stops;
    final sortedStops = List<RouteStop>.from(stops)
      ..sort((a, b) => a.sequenceIndex.compareTo(b.sequenceIndex));

    return Scaffold(
      appBar: AppBar(
        title: Text(route.name),
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
                  _DetailRow(label: 'Origin', value: route.origin ?? '—'),
                  _DetailRow(label: 'Destination', value: route.destination ?? '—'),
                  _DetailRow(label: 'Status', value: _statusLabel(route.status)),
                  if (route.scheduledAt != null)
                    _DetailRow(
                      label: 'Scheduled',
                      value: _formatDateTime(route.scheduledAt!),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Stops (${sortedStops.length})',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (sortedStops.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text('No stops on this route.'),
            )
          else
            ...sortedStops.map((stop) => Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text('${stop.sequenceIndex + 1}'),
                    ),
                    title: Text(stop.name),
                    subtitle: stop.address != null
                        ? Text(stop.address!, overflow: TextOverflow.ellipsis)
                        : null,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => _openStopDetail(context, stop),
                  ),
                )),
        ],
      ),
    );
  }

  void _openStopDetail(BuildContext context, RouteStop stop) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (context) => StopDetailScreen(
          route: route,
          stop: stop,
        ),
      ),
    );
  }

  String _statusLabel(RouteStatus status) {
    switch (status) {
      case RouteStatus.planned:
        return 'Planned';
      case RouteStatus.inProgress:
        return 'In progress';
      case RouteStatus.completed:
        return 'Completed';
      case RouteStatus.cancelled:
        return 'Cancelled';
    }
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
