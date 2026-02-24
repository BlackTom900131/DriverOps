import 'package:flutter/material.dart';
import '../../../shared/widgets/app_scaffold.dart';

class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final uploaded = <String>{};

  static const docs = <(String, bool, String)>[
    ('Government ID', true, 'Valid image/PDF, max size rule applies'),
    ('Driver license', true, 'Front and back required'),
    ('Vehicle registration', true, 'Must match declared vehicle'),
    ('Insurance certificate', true, 'Must not be expired'),
    ('Technical inspection', true, 'Expiration date tracked'),
    ('Additional certification', false, 'Only when route type requires it'),
  ];

  @override
  Widget build(BuildContext context) {
    final requiredDocs = docs.where((d) => d.$2).map((d) => d.$1).toSet();
    final allRequiredUploaded = requiredDocs.difference(uploaded).isEmpty;

    return AppScaffold(
      title: 'Document Upload',
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.rule_outlined),
              title: const Text('Compliance checklist'),
              subtitle: Text(
                '${
                    uploaded.length
                } uploaded | ${requiredDocs.length} mandatory documents',
              ),
            ),
          ),
          ...docs.map((doc) {
            final name = doc.$1;
            final mandatory = doc.$2;
            final hint = doc.$3;
            final isUploaded = uploaded.contains(name);
            return Card(
              child: ListTile(
                leading: Icon(
                  isUploaded ? Icons.check_circle_outline : Icons.description_outlined,
                  color: isUploaded ? const Color(0xFF2E7D32) : null,
                ),
                title: Text(mandatory ? '$name (Required)' : '$name (Optional)'),
                subtitle: Text(
                  isUploaded ? 'Uploaded. Awaiting verification.' : hint,
                ),
                trailing: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      if (isUploaded) {
                        uploaded.remove(name);
                      } else {
                        uploaded.add(name);
                      }
                    });
                  },
                  child: Text(isUploaded ? 'Replace' : 'Upload'),
                ),
              ),
            );
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton(
              onPressed: !allRequiredUploaded
                  ? null
                  : () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Submitted for verification (mock).'),
                        ),
                      ),
              child: const Text('Submit documents'),
            ),
          ),
        ],
      ),
    );
  }
}
