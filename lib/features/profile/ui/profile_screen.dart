import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/state/auth_state.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/status_badge.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);

    return AppScaffold(
      title: 'Profile',
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    auth.driverName,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  StatusBadge(status: auth.driverStatus),
                  const SizedBox(height: 12),
                  const Text('Email: driver@company.com'),
                ],
              ),
            ),
          ),
          Card(
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.fingerprint),
                  title: Text('Biometric login'),
                  subtitle: Text('Enabled (mock)'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.lock_clock_outlined),
                  title: Text('Session policy'),
                  subtitle: Text('Auto logout after inactivity (mock)'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton.tonal(
              onPressed: () {
                ref.read(authStateProvider.notifier).logout();
                context.go('/login');
              },
              child: const Text('Logout'),
            ),
          ),
        ],
      ),
    );
  }
}
