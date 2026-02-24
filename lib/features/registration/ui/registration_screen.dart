import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/state/auth_state.dart';
import '../../../shared/models/driver.dart';
import '../../../shared/widgets/app_scaffold.dart';

class RegistrationStepperScreen extends ConsumerStatefulWidget {
  const RegistrationStepperScreen({super.key});

  @override
  ConsumerState<RegistrationStepperScreen> createState() => _RegistrationStepperScreenState();
}

class _RegistrationStepperScreenState extends ConsumerState<RegistrationStepperScreen> {
  int _step = 0;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateProvider);

    return AppScaffold(
      title: 'Registration & Status',
      body: ListView(
        children: [
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text('Current status: ${auth.driverStatus.name}', style: Theme.of(context).textTheme.titleMedium),
                if (auth.driverStatus.name == 'rejected' && (auth.rejectionReason?.isNotEmpty ?? false))
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text('Rejection reason: ${auth.rejectionReason}', style: const TextStyle(color: Colors.red)),
                  ),
                const SizedBox(height: 12),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  OutlinedButton(
                    onPressed: () => ref.read(authStateProvider.notifier).setStatus(DriverStatus.pending),
                    child: const Text('Set Pending'),
                  ),
                  OutlinedButton(
                    onPressed: () => ref.read(authStateProvider.notifier).setStatus(DriverStatus.underVerification),
                    child: const Text('Set Under Verification'),
                  ),
                  OutlinedButton(
                    onPressed: () => ref.read(authStateProvider.notifier).setStatus(DriverStatus.approved),
                    child: const Text('Set Approved'),
                  ),
                  OutlinedButton(
                    onPressed: () => ref.read(authStateProvider.notifier).setStatus(
                      DriverStatus.rejected,
                      rejectionReason: 'Photo is blurry / document expired (mock)',
                    ),
                    child: const Text('Set Rejected'),
                  ),
                  OutlinedButton(
                    onPressed: () => ref.read(authStateProvider.notifier).setStatus(DriverStatus.suspended),
                    child: const Text('Set Suspended'),
                  ),
                ]),
              ]),
            ),
          ),
          Card(
            child: Stepper(
              currentStep: _step,
              onStepContinue: () => setState(() => _step = (_step + 1).clamp(0, 3)),
              onStepCancel: () => setState(() => _step = (_step - 1).clamp(0, 3)),
              onStepTapped: (i) => setState(() => _step = i),
              steps: const [
                Step(title: Text('Personal Info'), content: Text('Form fields placeholder')),
                Step(title: Text('Vehicle Info'), content: Text('Form fields placeholder')),
                Step(title: Text('Selfie'), content: Text('Camera capture placeholder')),
                Step(title: Text('Documents'), content: Text('Upload checklist placeholder')),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton.icon(
              onPressed: () => context.go('/registration/documents'),
              icon: const Icon(Icons.upload_file),
              label: const Text('Go to Document Upload Checklist'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class DocumentUploadScreen extends StatelessWidget {
  const DocumentUploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = const [
      'Government ID',
      'Driver’s license',
      'Certifications (if required)',
      'Vehicle registration certificate',
      'Insurance (valid)',
      'Technical inspection certificate (valid)',
    ];

    return AppScaffold(
      title: 'Document Upload (UI)',
      body: ListView(
        children: [
          const SizedBox(height: 8),
          ...items.map((name) => Card(
                child: ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: Text(name),
                  subtitle: const Text('Status: Not uploaded (mock)'),
                  trailing: OutlinedButton(
                    onPressed: () {},
                    child: const Text('Upload'),
                  ),
                ),
              )),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton(
              onPressed: () => context.go('/home'),
              child: const Text('Done (go Home)'),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
