import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import '../../app/navigation/app_routes.dart';

class AppBottomBar extends StatelessWidget {
  final int selectedIndex;

  const AppBottomBar({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: selectedIndex,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            context.go(AppRoutes.home);
            return;
          case 1:
            context.go(AppRoutes.homeRoutes);
            return;
          case 2:
            context.go(AppRoutes.homeQr);
            return;
          case 3:
            context.go(AppRoutes.homeMessages);
            return;
          case 4:
            context.go(AppRoutes.homeProfile);
            return;
        }
      },
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.home_outlined),
          selectedIcon: const Icon(Icons.home),
          label: tr('nav.home'),
        ),
        NavigationDestination(
          icon: const Icon(Icons.alt_route_outlined),
          selectedIcon: const Icon(Icons.alt_route),
          label: tr('nav.routes'),
        ),
        NavigationDestination(
          icon: const Icon(Icons.qr_code_scanner_outlined),
          selectedIcon: const Icon(Icons.qr_code_scanner),
          label: tr('nav.qr'),
        ),
        NavigationDestination(
          icon: const Icon(Icons.support_agent_outlined),
          selectedIcon: const Icon(Icons.support_agent),
          label: tr('nav.messages'),
        ),
        NavigationDestination(
          icon: const Icon(Icons.person_outline),
          selectedIcon: const Icon(Icons.person),
          label: tr('nav.profile'),
        ),
      ],
    );
  }
}
