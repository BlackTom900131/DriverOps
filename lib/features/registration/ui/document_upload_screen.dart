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
    ('Identificación oficial', true, 'Imagen/PDF válido, aplica regla de tamaño máximo'),
    ('Licencia de conducir', true, 'Se requieren frente y reverso'),
    ('Registro del vehículo', true, 'Debe coincidir con el vehículo declarado'),
    ('Certificado de seguro', true, 'No debe estar vencido'),
    ('Inspección técnica', true, 'Se controla la fecha de vencimiento'),
    ('Certificación adicional', false, 'Solo cuando el tipo de ruta lo requiere'),
  ];

  @override
  Widget build(BuildContext context) {
    final requiredDocs = docs.where((d) => d.$2).map((d) => d.$1).toSet();
    final allRequiredUploaded = requiredDocs.difference(uploaded).isEmpty;

    return AppScaffold(
      title: 'Carga de documentos',
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.rule_outlined),
              title: const Text('Lista de verificación de cumplimiento'),
              subtitle: Text(
                '${
                    uploaded.length
                } cargados | ${requiredDocs.length} documentos obligatorios',
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
                title: Text(mandatory ? '$name (Requerido)' : '$name (Opcional)'),
                subtitle: Text(
                  isUploaded ? 'Cargado. En espera de verificación.' : hint,
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
                  child: Text(isUploaded ? 'Reemplazar' : 'Cargar'),
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
                          content: Text('Enviado para verificación (simulado).'),
                        ),
                      ),
              child: const Text('Enviar documentos'),
            ),
          ),
        ],
      ),
    );
  }
}
