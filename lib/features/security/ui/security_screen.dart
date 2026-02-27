import 'package:flutter/material.dart';

import '../../../shared/widgets/app_scaffold.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Seguridad del usuario',
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.lock_outline),
              title: Text('Cambiar contraseña'),
              subtitle: Text('Actualice la contraseña de su cuenta con regularidad.'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.phonelink_lock_outlined),
              title: Text('Autenticación de dos factores'),
              subtitle: Text('Habilítela para mayor protección de la cuenta.'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.history_toggle_off_outlined),
              title: Text('Actividad de inicio de sesión'),
              subtitle: Text('Revise sesiones y dispositivos recientes.'),
            ),
          ),
        ],
      ),
    );
  }
}
