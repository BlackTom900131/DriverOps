import 'package:flutter/material.dart';

import '../../../shared/widgets/app_scaffold.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Mensajes del servidor',
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.campaign_outlined),
              title: Text('Aviso del sistema'),
              subtitle: Text('No hay mensajes nuevos del servidor.'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.verified_outlined),
              title: Text('Actualización de verificación'),
              subtitle: Text('Las últimas actualizaciones de verificación aparecerán aquí.'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }
}
