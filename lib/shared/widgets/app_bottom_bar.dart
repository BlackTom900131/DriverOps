import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            context.go('/home');
          case 1:
            context.go('/home/routes');
          case 2:
            context.go('/home/qr');
          case 3:
            context.go('/home/messages');
          case 4:
            context.go('/home/profile');
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.alt_route_outlined),
          selectedIcon: Icon(Icons.alt_route),
          label: 'Router',
        ),
        NavigationDestination(
          icon: Icon(Icons.qr_code_scanner_outlined),
          selectedIcon: Icon(Icons.qr_code_scanner),
          label: 'QR',
        ),
        NavigationDestination(
          icon: Icon(Icons.support_agent_outlined),
          selectedIcon: Icon(Icons.support_agent),
          label: 'Contact Us',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}
