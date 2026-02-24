import 'package:flutter/material.dart';

/// Proof of Delivery (POD) screen for confirming a completed delivery.
class PodScreen extends StatefulWidget {
  const PodScreen({super.key});

  @override
  State<PodScreen> createState() => _PodScreenState();
}

class _PodScreenState extends State<PodScreen> {
  final _recipientController = TextEditingController();
  final _notesController = TextEditingController();
  bool _recipientPresent = true;

  @override
  void dispose() {
    _recipientController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    // TODO: Persist POD data via delivery_provider.
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Proof of Delivery'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SwitchListTile(
              value: _recipientPresent,
              title: const Text('Recipient present'),
              onChanged: (v) => setState(() => _recipientPresent = v),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _recipientController,
              decoration: const InputDecoration(
                labelText: 'Recipient name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Notes (optional)',
                hintText: 'e.g. left at front desk',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Confirm delivery'),
            ),
          ],
        ),
      ),
    );
  }
}
