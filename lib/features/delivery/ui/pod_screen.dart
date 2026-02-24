import 'package:flutter/material.dart';
import '../../../shared/widgets/app_scaffold.dart';

class PodScreen extends StatefulWidget {
  final String routeId;
  final String stopId;

  const PodScreen({super.key, required this.routeId, required this.stopId});

  @override
  State<PodScreen> createState() => _PodScreenState();
}

class _PodScreenState extends State<PodScreen> {
  bool photoAdded = false;
  bool signatureAdded = false;

  @override
  Widget build(BuildContext context) {
    final canSubmit = photoAdded && signatureAdded;
    return AppScaffold(
      title: 'Proof of Delivery',
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: const Text('POD Evidence'),
              subtitle: Text('Route: ${widget.routeId} | Stop: ${widget.stopId}'),
            ),
          ),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_camera_outlined),
                  title: const Text('Photo capture (mandatory)'),
                  trailing: OutlinedButton(
                    onPressed: () => setState(() => photoAdded = true),
                    child: Text(photoAdded ? 'Added' : 'Capture'),
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.draw_outlined),
                  title: const Text('Recipient signature (mandatory)'),
                  trailing: OutlinedButton(
                    onPressed: () => setState(() => signatureAdded = true),
                    child: Text(signatureAdded ? 'Added' : 'Sign'),
                  ),
                ),
                const Divider(height: 1),
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: TextField(decoration: InputDecoration(labelText: 'Recipient ID')),
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
              onPressed: !canSubmit
                  ? null
                  : () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Delivered with POD evidence.')),
                      ),
              child: const Text('Submit POD'),
            ),
          ),
        ],
      ),
    );
  }
}
