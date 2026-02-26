import 'package:flutter/material.dart';

import '../../../shared/widgets/app_scaffold.dart';

class QrScreen extends StatelessWidget {
  const QrScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const AppScaffold(
      title: 'QR',
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.qr_code_scanner, size: 72),
            SizedBox(height: 12),
            Text(
              'QR tools',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 6),
            Text('Use this page for quick QR scan actions.'),
          ],
        ),
      ),
    );
  }
}
