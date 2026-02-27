import 'package:flutter/material.dart';
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
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Inicio',
        ),
        NavigationDestination(
          icon: Icon(Icons.alt_route_outlined),
          selectedIcon: Icon(Icons.alt_route),
          label: 'Rutas',
        ),
        NavigationDestination(
          icon: Icon(Icons.qr_code_scanner_outlined),
          selectedIcon: Icon(Icons.qr_code_scanner),
          label: 'QR',
        ),
        NavigationDestination(
          icon: Icon(Icons.support_agent_outlined),
          selectedIcon: Icon(Icons.support_agent),
          label: 'Contacto',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Perfil',
        ),
      ],
    );
  }
}
