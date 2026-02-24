import 'package:flutter/material.dart';

/// Screen for capturing a failed delivery attempt.
class FailedDeliveryScreen extends StatefulWidget {
  const FailedDeliveryScreen({super.key});

  @override
  State<FailedDeliveryScreen> createState() => _FailedDeliveryScreenState();
}

class _FailedDeliveryScreenState extends State<FailedDeliveryScreen> {
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    // TODO: Persist failed delivery reason via delivery_provider.
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Failed Delivery'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Describe why the delivery failed:',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _reasonController,
              maxLines: 4,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'e.g. customer not at home, wrong address',
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _submit,
              child: const Text('Save failed delivery'),
            ),
          ],
        ),
      ),
    );
  }
}
