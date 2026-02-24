import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:driversystem/shared/widgets/offline_banner.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/state/auth_state.dart';
import '../models/driver.dart';

class AppScaffold extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _tabIndex(location);
    final driverStatus = ref.watch(authStateProvider.select((s) => s.driverStatus));
    final statusColor = _statusColor(driverStatus);

    return Scaffold(
      appBar: AppBar(title: Text(title), actions: actions),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7FAFF), Color(0xFFF0F4FB)],
          ),
        ),
        child: Column(
          children: [
            if (showOfflineBanner) const OfflineBanner(),
            Expanded(child: body),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBarTheme(
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
                context.go('/home/offline-queue');
              case 3:
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
              icon: Icon(Icons.cloud_sync_outlined),
              selectedIcon: Icon(Icons.cloud_sync),
              label: 'Offline',
            ),
            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  int _tabIndex(String location) {
    if (location.startsWith('/home/profile')) return 3;
    if (location.startsWith('/home/offline-queue')) return 2;
    if (location.startsWith('/home/status') || location.startsWith('/registration')) {
      return 1;
    }
    return 0;
  }

  Color _statusColor(DriverStatus status) {
    return switch (status) {
      DriverStatus.none => const Color(0xFF8E8E93),
      DriverStatus.pending => const Color(0xFFFF9F0A),
      DriverStatus.underVerification => const Color(0xFF0A84FF),
      DriverStatus.approved => const Color(0xFF34C759),
      DriverStatus.rejected => const Color(0xFFFF3B30),
      DriverStatus.suspended => const Color(0xFF8E8E93),
    };
  }
}
