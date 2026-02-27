import 'package:flutter/material.dart';
import '../../../shared/widgets/app_scaffold.dart';

class FailedDeliveryScreen extends StatefulWidget {
  final String routeId;
  final String stopId;

  const FailedDeliveryScreen({
    super.key,
    required this.routeId,
    required this.stopId,
  });

  @override
  State<FailedDeliveryScreen> createState() => _FailedDeliveryScreenState();
}

class _FailedDeliveryScreenState extends State<FailedDeliveryScreen> {
  String reason = 'Cliente no disponible';
  final noteController = TextEditingController();
  bool evidenceAdded = false;

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final needsNote = reason == 'Otro (requiere nota)';
    final canSubmit = !needsNote || noteController.text.trim().isNotEmpty;

    return AppScaffold(
      title: 'Entrega fallida',
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Ruta: ${widget.routeId} | Parada: ${widget.stopId}'),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: reason,
                    items: const [
                      'Cliente no disponible',
                      'Dirección incorrecta',
                      'Rechazado por el cliente',
                      'Otro (requiere nota)',
                    ].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                    onChanged: (v) => setState(() => reason = v ?? reason),
                    decoration: const InputDecoration(labelText: 'Motivo'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: noteController,
                    onChanged: (_) => setState(() {}),
                    maxLines: 3,
                    decoration: InputDecoration(
                      labelText:
                          needsNote ? 'Nota (requerida)' : 'Nota (opcional)',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () => setState(() => evidenceAdded = true),
                        icon: const Icon(Icons.photo_camera_outlined),
                        label:
                            Text(evidenceAdded ? 'Evidencia agregada' : 'Agregar foto'),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Política de evidencia configurable',
                        style: TextStyle(color: Colors.grey.shade700),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: !canSubmit
                          ? null
                          : () => ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Fallo enviado. Incidente creado vía API.',
                                  ),
                                ),
                              ),
                      child: const Text('Enviar fallo'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
