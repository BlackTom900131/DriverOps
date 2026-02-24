import 'package:flutter/material.dart';
import '../../../shared/widgets/app_scaffold.dart';

class DocumentUploadScreen extends StatelessWidget {
  const DocumentUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      'Government ID',
      'Driver’s license',
      'Certifications (if required)',
      'Vehicle registration certificate',
      'Insurance (valid)',
      'Technical inspection certificate (valid)',
    ];

    return AppScaffold(
      title: 'Document Upload (UI)',
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ...items.map((name) => Card(
                child: ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: Text(name),
                  subtitle: const Text('Status: Not uploaded (mock)'),
                  trailing: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Upload'),
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
