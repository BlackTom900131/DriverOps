import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:driversystem/shared/widgets/offline_banner.dart';
import '../../features/auth/state/auth_state.dart';
import 'app_bottom_bar.dart';
import 'package:go_router/go_router.dart';

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
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _tabIndex(location);
    final appBarActions = <Widget>[...?actions, const _UserMenuButton()];

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
      bottomNavigationBar: AppBottomBar(selectedIndex: selectedIndex),
    );
  }

  int _tabIndex(String location) {
    if (location.startsWith('/home/routes')) return 1;
    if (location.startsWith('/home/qr')) return 2;
    if (location.startsWith('/home/messages')) return 3;
    if (location.startsWith('/home/profile')) return 4;
    if (location.startsWith('/home/security')) return 4;
    return 0;
  }
}

enum _UserMenuAction {
  profile,
  status,
  vehicle,
  document,
  security,
  messages,
  logout,
}

class _UserMenuButton extends ConsumerWidget {
  const _UserMenuButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return PopupMenuButton<_UserMenuAction>(
      tooltip: 'User menu',
      onSelected: (action) => _handleSelection(context, ref, action),
      itemBuilder: (context) => const [
        PopupMenuItem<_UserMenuAction>(
          value: _UserMenuAction.profile,
          child: _UserMenuItemContent(
            icon: Icons.person_outline,
            label: 'Profile',
          ),
        ),
        PopupMenuItem<_UserMenuAction>(
          value: _UserMenuAction.status,
          child: _UserMenuItemContent(
            icon: Icons.verified_user_outlined,
            label: 'Status',
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
        PopupMenuItem<_UserMenuAction>(
          value: _UserMenuAction.logout,
          child: _UserMenuItemContent(
            icon: Icons.logout_outlined,
            label: 'Logout',
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

  void _handleSelection(
    BuildContext context,
    WidgetRef ref,
    _UserMenuAction action,
  ) {
    if (action == _UserMenuAction.logout) {
      ref.read(authStateProvider.notifier).logout();
      return;
    }

    final targetRoute = switch (action) {
      _UserMenuAction.status => '/home/status',
      _UserMenuAction.profile => '/home/profile',
      _UserMenuAction.vehicle => '/home/vehicle',
      _UserMenuAction.document => '/home/documents',
      _UserMenuAction.security => '/home/security',
      _UserMenuAction.messages => '/home/messages',
      _UserMenuAction.logout => '/login',
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
      children: [Icon(icon, size: 18), const SizedBox(width: 10), Text(label)],
    );
  }
}
