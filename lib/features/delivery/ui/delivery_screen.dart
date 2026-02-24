import 'package:flutter/material.dart';
import 'pod_screen.dart';
import 'failed_delivery_screen.dart';

/// Delivery screen showing the active delivery and actions.
class DeliveryScreen extends StatelessWidget {
  const DeliveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Delivery'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: ListTile(
                leading: const Icon(Icons.local_shipping),
                title: const Text('Current delivery'),
                subtitle: const Text('Destination: TBD\nETA: TBD'),
                isThreeLine: true,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const PodScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.check_circle_outline),
              label: const Text('Complete delivery (POD)'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (context) => const FailedDeliveryScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.error_outline),
              label: const Text('Mark as failed'),
            ),
          ],
        ),
      ),
    );
  }
}
