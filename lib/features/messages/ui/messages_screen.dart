import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../shared/widgets/app_scaffold.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: tr('messages.title'),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.campaign_outlined),
              title: Text(tr('messages.system_notice_title')),
              subtitle: Text(tr('messages.system_notice_subtitle')),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.verified_outlined),
              title: Text(tr('messages.verification_update_title')),
              subtitle: Text(tr('messages.verification_update_subtitle')),
              trailing: const Icon(Icons.chevron_right),
            ),
          ),
        ],
      ),
    );
  }
}
