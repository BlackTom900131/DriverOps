import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/navigation/app_routes.dart';
import '../state/workday_state.dart';
import '../../offline_queue/state/offline_queue_state.dart';
import '../../../shared/widgets/app_scaffold.dart';

class StartWorkdayScreen extends ConsumerStatefulWidget {
  const StartWorkdayScreen({super.key});

  @override
  ConsumerState<StartWorkdayScreen> createState() => _StartWorkdayScreenState();
}

class _StartWorkdayScreenState extends ConsumerState<StartWorkdayScreen> {
  bool confirm = false;
  bool gpsValidation = true;

  @override
  Widget build(BuildContext context) {
    final offline = ref.watch(offlineQueueProvider).isOffline;
    return AppScaffold(
      title: 'Start Workday',
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
                  const Text(
                    'Before starting',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    offline
                        ? 'Offline mode active: start event will be queued.'
                        : 'Online mode: start event will be sent immediately.',
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    value: confirm,
                    onChanged: (v) => setState(() => confirm = v ?? false),
                    title: const Text('I confirm I am starting my workday now'),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  SwitchListTile(
                    value: gpsValidation,
                    onChanged: (v) => setState(() => gpsValidation = v),
                    title: const Text('GPS validation enabled'),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: !confirm
                          ? null
                          : () {
                              ref.read(workdayProvider.notifier).start();
                              ref.read(offlineQueueProvider.notifier).addMockEvent();
                              context.go(AppRoutes.home);
                            },
                      child: const Text('Start Workday'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
