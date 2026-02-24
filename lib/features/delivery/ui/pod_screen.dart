import 'package:flutter/material.dart';
import '../../../shared/widgets/app_scaffold.dart';

class PodScreen extends StatelessWidget {
  final String routeId;
  final String stopId;

  const PodScreen({super.key, required this.routeId, required this.stopId});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Proof of Delivery',
      body: ListView(
        children: [
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: const Text('POD Evidence (UI placeholders)'),
              subtitle: Text('Route: $routeId • Stop: $stopId'),
            ),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: const Text('Photo capture'),
                  trailing: OutlinedButton(onPressed: () {}, child: const Text('Capture')),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.draw_outlined),
                  title: const Text('Recipient signature'),
                  trailing: OutlinedButton(onPressed: () {}, child: const Text('Sign')),
                ),
                const Divider(height: 1),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: TextField(decoration: InputDecoration(labelText: 'Recipient ID (UI)')),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: TextField(
                    maxLines: 3,
                    decoration: InputDecoration(labelText: 'Notes (optional)'),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton(
              onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Delivered + POD saved (mock)')),
              ),
              child: const Text('Submit POD'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
