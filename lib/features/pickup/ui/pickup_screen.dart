import 'package:flutter/material.dart';

/// Pickup screen for viewing upcoming and active pickups.
class PickupScreen extends StatefulWidget {
  const PickupScreen({super.key});

  @override
  State<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends State<PickupScreen> {
  bool _showOnlyToday = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pickups'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _showOnlyToday ? 'Today\'s pickups' : 'All pickups',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Switch.adaptive(
                  value: _showOnlyToday,
                  onChanged: (v) {
                    setState(() => _showOnlyToday = v);
                  },
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 5,
              itemBuilder: (context, index) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: ListTile(
                    leading: const Icon(Icons.local_shipping),
                    title: Text('Pickup #${index + 1}'),
                    subtitle: const Text('Location: TBD\nTime: TBD'),
                    isThreeLine: true,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      // TODO: Navigate to a pickup detail screen when added.
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
