import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/state/auth_state.dart';
import '../state/workday_state.dart';
import '../../../shared/widgets/app_scaffold.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    final workday = ref.watch(workdayProvider);

    return AppScaffold(
      title: 'Home',
      actions: [
        IconButton(
          tooltip: 'Profile',
          onPressed: () => context.go('/home/profile'),
          icon: const Icon(Icons.person_outline),
        ),
        IconButton(
          tooltip: 'Offline Queue',
          onPressed: () => context.go('/home/offline-queue'),
          icon: const Icon(Icons.cloud_off_outlined),
        ),
      ],
      body: ListView(
        children: [
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Welcome, ${auth.driverName}', style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 8),
                Text('Driver status: ${auth.driverStatus.name}'),
                const SizedBox(height: 8),
                Text('Workday: ${workday.started ? "Started" : "Not started"}'),
                if (workday.startedAt != null) Text('Started at: ${workday.startedAt}'),
                const SizedBox(height: 12),
                Wrap(spacing: 10, runSpacing: 10, children: [
                  FilledButton(
                    onPressed: workday.started ? null : () => context.go('/home/start-workday'),
                    child: const Text('Start Workday'),
                  ),
                  OutlinedButton(
                    onPressed: () => context.go('/home/routes'),
                    child: const Text('Routes'),
                  ),
                ]),
              ]),
            ),
          ),
          Card(
            child: ListTile(
              title: const Text('Notifications (mock)'),
              subtitle: const Text('Route updates / urgent instructions will appear here.'),
              trailing: const Icon(Icons.notifications_none),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}