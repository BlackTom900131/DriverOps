import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../shared/widgets/app_scaffold.dart';

class QrScreen extends StatelessWidget {
  const QrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: tr('qr.title'),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.qr_code_scanner, size: 72),
            const SizedBox(height: 12),
            Text(
              tr('qr.tools_title'),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(tr('qr.subtitle')),
          ],
        ),
      ),
    );
  }
}
