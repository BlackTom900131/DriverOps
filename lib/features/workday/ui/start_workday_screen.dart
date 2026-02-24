import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../state/workday_state.dart';
import '../../../shared/widgets/app_scaffold.dart';

class StartWorkdayScreen extends ConsumerStatefulWidget {
  const StartWorkdayScreen({super.key});

  @override
  ConsumerState<StartWorkdayScreen> createState() => _StartWorkdayScreenState();
}

class _StartWorkdayScreenState extends ConsumerState<StartWorkdayScreen> {
  bool confirm = false;
  bool gpsValidation = false;

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Start Workday',
      body: ListView(
        children: [
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                const Text('You must confirm to start your workday.'),
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
                  title: const Text('GPS validation at start (UI only)'),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: !confirm
                        ? null
                        : () {
                            ref.read(workdayProvider.notifier).start();
                            context.go('/home');
                          },
                    child: const Text('Start Workday'),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}