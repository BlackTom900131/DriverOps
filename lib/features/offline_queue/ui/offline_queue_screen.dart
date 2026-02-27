import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../state/offline_queue_state.dart';

class OfflineQueueScreen extends ConsumerWidget {
  const OfflineQueueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(offlineQueueProvider);
    final notifier = ref.read(offlineQueueProvider.notifier);

    return AppScaffold(
      title: 'Cola sin conexión',
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: Icon(
                state.isOffline ? Icons.cloud_off_outlined : Icons.cloud_done_outlined,
              ),
              title: Text(state.isOffline ? 'Modo: SIN CONEXIÓN' : 'Modo: EN LÍNEA'),
              subtitle: Text('Eventos pendientes: ${state.pendingEvents}'),
              trailing: FilledButton(
                onPressed: notifier.toggleOffline,
                child: Text(state.isOffline ? 'Conectarse' : 'Desconectarse'),
              ),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.sync_outlined),
              title: const Text('Sincronizar cola ahora'),
              subtitle:
                  const Text('Los reintentos y conflictos dependen del backend.'),
              onTap: state.isOffline || state.pendingEvents == 0
                  ? null
                  : () {
                      notifier.clear();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Cola sincronizada correctamente (simulado).'),
                        ),
                      );
                    },
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.add),
              title: const Text('Agregar evento simulado en cola'),
              onTap: notifier.addMockEvent,
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.delete_outline),
              title: const Text('Limpiar cola local'),
              onTap: notifier.clear,
            ),
          ),
        ],
      ),
    );
  }
}
