import 'package:flutter/material.dart';
import 'package:driversystem/shared/widgets/offline_banner.dart';

class AppScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool showOfflineBanner;

  const AppScaffold({
    super.key,
    required this.title,
    required this.body,
    this.actions,
    this.showOfflineBanner = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: Column(
        children: [
          if (showOfflineBanner) OfflineBanner(),
          Expanded(child: body),
        ],
      ),
    );
  }
}