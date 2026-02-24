import 'package:flutter/material.dart';

/// Screen to confirm and start a new workday (clock in).
class StartWorkdayScreen extends StatefulWidget {
  const StartWorkdayScreen({super.key});

  @override
  State<StartWorkdayScreen> createState() => _StartWorkdayScreenState();
}

class _StartWorkdayScreenState extends State<StartWorkdayScreen> {
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _startWorkday() {
    // TODO: Persist via workday_provider / workday_state
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final timeStr =
        '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    final dateStr =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Start workday'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 48,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      timeStr,
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Text(
                      dateStr,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextFormField(
              controller: _notesController,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                border: OutlineInputBorder(),
                hintText: 'e.g. route, vehicle',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _startWorkday,
              icon: const Icon(Icons.play_arrow),
              label: const Text('Clock in'),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
          ],
        ),
      ),
    );
  }
}
