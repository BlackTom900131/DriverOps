import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../shared/widgets/app_scaffold.dart';

class SecurityScreen extends StatelessWidget {
  const SecurityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: tr('security.title'),
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.lock_outline),
              title: Text(tr('security.change_password_title')),
              subtitle: Text(tr('security.change_password_subtitle')),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.phonelink_lock_outlined),
              title: Text(tr('security.two_factor_title')),
              subtitle: Text(tr('security.two_factor_subtitle')),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.history_toggle_off_outlined),
              title: Text(tr('security.login_activity_title')),
              subtitle: Text(tr('security.login_activity_subtitle')),
            ),
          ),
        ],
      ),
    );
  }
}
