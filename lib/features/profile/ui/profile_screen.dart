import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/state/auth_state.dart';
import '../../../shared/widgets/app_scaffold.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);

    return AppScaffold(
      title: 'Profile',
      body: ListView(
        children: [
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              title: Text(auth.driverName),
              subtitle: Text('Status: ${auth.driverStatus.name}\nEmail: driver@company.com (mock)'),
              isThreeLine: true,
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