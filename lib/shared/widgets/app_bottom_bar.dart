import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomBar extends StatelessWidget {
  final int selectedIndex;
  final Color statusColor;

  const AppBottomBar({
    super.key,
    required this.selectedIndex,
    required this.statusColor,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBarTheme(
      data: NavigationBarThemeData(
        indicatorColor: selectedIndex == 1
            ? statusColor.withValues(alpha: 0.2)
            : null,
      ),
      child: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/home');
            case 1:
              context.go('/home/status');
            case 2:
              context.go('/home/vehicle');
            case 3:
              context.go('/home/documents');
            case 4:
              context.go('/home/profile');
          }
        },
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: const Icon(Icons.verified_user_outlined),
            selectedIcon: Icon(Icons.verified_user, color: statusColor),
            label: 'Status',
          ),
          const NavigationDestination(
            icon: Icon(Icons.local_shipping_outlined),
            selectedIcon: Icon(Icons.local_shipping),
            label: 'Vehicle',
          ),
          const NavigationDestination(
            icon: Icon(Icons.description_outlined),
            selectedIcon: Icon(Icons.description),
            label: 'Document',
          ),
          const NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
