import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/navigation/app_routes.dart';
import '../../features/auth/state/auth_state.dart';
import 'offline_banner.dart';
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
    if (AppRoutes.isInSection(location, AppRoutes.homeRoutes)) return 1;
    if (AppRoutes.isInSection(location, AppRoutes.homeQr)) return 2;
    if (AppRoutes.isInSection(location, AppRoutes.homeMessages)) return 3;
    if (AppRoutes.isInSection(location, AppRoutes.homeProfile)) return 4;
    if (AppRoutes.isInSection(location, AppRoutes.homeSecurity)) return 4;
    if (AppRoutes.isInSection(location, AppRoutes.homeSettings)) return 4;
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
  settings,
  logout,
}

class _UserMenuButton extends ConsumerWidget {
  const _UserMenuButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).colorScheme;
    final location = GoRouterState.of(context).matchedLocation;

    return PopupMenuButton<_UserMenuAction>(
      tooltip: tr('menu.user_tooltip'),
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.18),
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: colors.outline.withValues(alpha: 0.55)),
      ),
      constraints: const BoxConstraints(minWidth: 230),
      onSelected: (action) => _handleSelection(context, ref, action),
      itemBuilder: (context) => [
        PopupMenuItem<_UserMenuAction>(
          value: _UserMenuAction.profile,
          child: _UserMenuItemContent(
            icon: Icons.person_outline,
            label: tr('menu.profile'),
            selected: AppRoutes.isInSection(location, AppRoutes.homeProfile),
          ),
        ),
        PopupMenuItem<_UserMenuAction>(
          value: _UserMenuAction.status,
          child: _UserMenuItemContent(
            icon: Icons.verified_user_outlined,
            label: tr('menu.status'),
            selected: location == AppRoutes.homeStatus,
          ),
        ),
        PopupMenuItem<_UserMenuAction>(
          value: _UserMenuAction.vehicle,
          child: _UserMenuItemContent(
            icon: Icons.local_shipping_outlined,
            label: tr('menu.vehicle'),
            selected: AppRoutes.isInSection(location, AppRoutes.homeVehicle),
          ),
        ),
        PopupMenuItem<_UserMenuAction>(
          value: _UserMenuAction.document,
          child: _UserMenuItemContent(
            icon: Icons.description_outlined,
            label: tr('menu.documents'),
            selected: AppRoutes.isInSection(location, AppRoutes.homeDocuments),
          ),
        ),
        PopupMenuItem<_UserMenuAction>(
          value: _UserMenuAction.security,
          child: _UserMenuItemContent(
            icon: Icons.security_outlined,
            label: tr('menu.security'),
            selected: AppRoutes.isInSection(location, AppRoutes.homeSecurity),
          ),
        ),
        PopupMenuItem<_UserMenuAction>(
          value: _UserMenuAction.messages,
          child: _UserMenuItemContent(
            icon: Icons.message_outlined,
            label: tr('menu.messages'),
            selected: AppRoutes.isInSection(location, AppRoutes.homeMessages),
          ),
        ),
        PopupMenuItem<_UserMenuAction>(
          value: _UserMenuAction.settings,
          child: _UserMenuItemContent(
            icon: Icons.settings_outlined,
            label: tr('menu.settings'),
            selected: AppRoutes.isInSection(location, AppRoutes.homeSettings),
          ),
        ),
        const PopupMenuDivider(height: 8),
        PopupMenuItem<_UserMenuAction>(
          value: _UserMenuAction.logout,
          child: _UserMenuItemContent(
            icon: Icons.logout_outlined,
            label: tr('menu.logout'),
            isDestructive: true,
          ),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: CircleAvatar(
          radius: 17,
          backgroundColor: Colors.white.withValues(alpha: 0.98),
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colors.primary.withValues(alpha: 0.35),
                width: 1.1,
              ),
            ),
            alignment: Alignment.center,
            child: Icon(
              Icons.person,
              size: 18,
              color: const Color(0xFF0B4FAE),
            ),
          ),
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
      _UserMenuAction.status => AppRoutes.homeStatus,
      _UserMenuAction.profile => AppRoutes.homeProfile,
      _UserMenuAction.vehicle => AppRoutes.homeVehicle,
      _UserMenuAction.document => AppRoutes.homeDocuments,
      _UserMenuAction.security => AppRoutes.homeSecurity,
      _UserMenuAction.messages => AppRoutes.homeMessages,
      _UserMenuAction.settings => AppRoutes.homeSettings,
      _UserMenuAction.logout => AppRoutes.login,
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
  final bool selected;
  final bool isDestructive;

  const _UserMenuItemContent({
    required this.icon,
    required this.label,
    this.selected = false,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final textColor = isDestructive
        ? colors.error
        : (selected ? colors.primary : colors.onSurface);
    final iconBg = isDestructive
        ? colors.error.withValues(alpha: 0.12)
        : (selected
              ? colors.primary.withValues(alpha: 0.12)
              : colors.primary.withValues(alpha: 0.08));

    return Container(
      decoration: BoxDecoration(
        color: selected ? colors.primary.withValues(alpha: 0.08) : null,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: iconBg,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 16, color: textColor),
          ),
          const SizedBox(width: 10),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
