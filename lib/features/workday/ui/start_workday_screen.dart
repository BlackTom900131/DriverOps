import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
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
      title: tr('start_workday.title'),
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
                    tr('start_workday.before_starting'),
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    offline
                        ? tr('start_workday.offline_mode')
                        : tr('start_workday.online_mode'),
                  ),
                  const SizedBox(height: 12),
                  CheckboxListTile(
                    value: confirm,
                    onChanged: (v) => setState(() => confirm = v ?? false),
                    title: Text(tr('start_workday.confirm_now')),
                    controlAffinity: ListTileControlAffinity.leading,
                  ),
                  SwitchListTile(
                    value: gpsValidation,
                    onChanged: (v) => setState(() => gpsValidation = v),
                    title: Text(tr('start_workday.gps_validation_enabled')),
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
                      child: Text(tr('start_workday.start_button')),
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
