import 'package:flutter/material.dart';

import '../../../shared/widgets/app_scaffold.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'User Security',
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.lock_outline),
              title: Text('Change password'),
              subtitle: Text('Update your account password regularly.'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.phonelink_lock_outlined),
              title: Text('Two-factor authentication'),
              subtitle: Text('Enable for extra account protection.'),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.history_toggle_off_outlined),
              title: Text('Login activity'),
              subtitle: Text('Review recent login sessions and devices.'),
            ),
          ),
        ],
      ),
    );
  }
}
