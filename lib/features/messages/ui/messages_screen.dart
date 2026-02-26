import 'package:flutter/material.dart';

import '../../../shared/widgets/app_scaffold.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Server Messages',
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        children: const [
          Card(
            child: ListTile(
              leading: Icon(Icons.campaign_outlined),
              title: Text('System notice'),
              subtitle: Text('No new messages from server.'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
          Card(
            child: ListTile(
              leading: Icon(Icons.verified_outlined),
              title: Text('Verification update'),
              subtitle: Text('Latest verification updates will appear here.'),
              trailing: Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }
}
