import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:driversystem/shared/widgets/offline_banner.dart';
import '../../features/auth/state/auth_state.dart';
import '../models/driver.dart';
import 'app_bottom_bar.dart';
import 'package:go_router/go_router.dart';

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
    final driverStatus = ref.watch(
      authStateProvider.select((s) => s.driverStatus),
    );
    final statusColor = _statusColor(driverStatus);
    final appBarActions = <Widget>[
      ...?actions,
      const _UserMenuButton(),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(title), actions: appBarActions),
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
      bottomNavigationBar: AppBottomBar(
        selectedIndex: selectedIndex,
        statusColor: statusColor,
      ),
    );
  }

  int _tabIndex(String location) {
    if (location.startsWith('/home/profile')) return 4;
    if (location.startsWith('/home/security')) return 4;
    if (location.startsWith('/home/messages')) return 4;
    if (location.startsWith('/home/documents')) return 3;
    if (location.startsWith('/home/vehicle')) return 2;
    if (location.startsWith('/home/status') ||
        location.startsWith('/registration')) {
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

enum _UserMenuAction { profile, vehicle, document, security, messages }

class _UserMenuButton extends StatelessWidget {
  const _UserMenuButton();

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<_UserMenuAction>(
      tooltip: 'User menu',
      onSelected: (action) => _handleSelection(context, action),
      itemBuilder: (context) => const [
        PopupMenuItem<_UserMenuAction>(
          value: _UserMenuAction.profile,
          child: _UserMenuItemContent(
            icon: Icons.person_outline,
            label: 'Profile',
          ),
        ),
        PopupMenuItem<_UserMenuAction>(
          value: _UserMenuAction.vehicle,
          child: _UserMenuItemContent(
            icon: Icons.local_shipping_outlined,
            label: 'Vehicle',
          ),
        ),
        PopupMenuItem<_UserMenuAction>(
          value: _UserMenuAction.document,
          child: _UserMenuItemContent(
            icon: Icons.description_outlined,
            label: 'Document',
          ),
        ),
        PopupMenuItem<_UserMenuAction>(
          value: _UserMenuAction.security,
          child: _UserMenuItemContent(
            icon: Icons.security_outlined,
            label: 'Security',
          ),
        ),
        PopupMenuItem<_UserMenuAction>(
          value: _UserMenuAction.messages,
          child: _UserMenuItemContent(
            icon: Icons.message_outlined,
            label: 'Messages',
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: CircleAvatar(
          radius: 16,
          child: const Icon(Icons.person, size: 18),
        ),
      ),
    );
  }

  void _handleSelection(BuildContext context, _UserMenuAction action) {
    final targetRoute = switch (action) {
      _UserMenuAction.profile => '/home/profile',
      _UserMenuAction.vehicle => '/home/vehicle',
      _UserMenuAction.document => '/home/documents',
      _UserMenuAction.security => '/home/security',
      _UserMenuAction.messages => '/home/messages',
    };

    final location = GoRouterState.of(context).matchedLocation;
    if (location != targetRoute) {
      context.go(targetRoute);
    }
  }
}

class _UserMenuItemContent extends StatelessWidget {
  final IconData icon;
  final String label;

  const _UserMenuItemContent({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 10),
        Text(label),
      ],
    );
  }
}
