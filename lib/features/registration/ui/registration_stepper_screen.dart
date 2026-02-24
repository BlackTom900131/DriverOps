import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/state/auth_state.dart';
import '../../../shared/models/driver.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/widgets/status_badge.dart';

class RegistrationStepperScreen extends ConsumerStatefulWidget {
  const RegistrationStepperScreen({super.key});

  @override
  ConsumerState<RegistrationStepperScreen> createState() =>
      _RegistrationStepperScreenState();
}

class _RegistrationStepperScreenState
    extends ConsumerState<RegistrationStepperScreen> {
  int step = 0;

  @override
  Widget build(BuildContext context) {
    final auth = ref.watch(authStateProvider);
    final notifier = ref.read(authStateProvider.notifier);

    return AppScaffold(
      title: 'Registration & Compliance',
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
                    'Verification status',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(height: 8),
                  StatusBadge(status: auth.driverStatus),
                  if (auth.driverStatus == DriverStatus.rejected &&
                      (auth.rejectionReason?.isNotEmpty ?? false))
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Rejection reason: ${auth.rejectionReason}',
                        style: const TextStyle(
                          color: Color(0xFFC62828),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton(
                        onPressed: () => notifier.setStatus(DriverStatus.pending),
                        child: const Text('Pending'),
                      ),
                      OutlinedButton(
                        onPressed: () => notifier.setStatus(
                          DriverStatus.underVerification,
                        ),
                        child: const Text('Under Verification'),
                      ),
                      OutlinedButton(
                        onPressed: () => notifier.setStatus(DriverStatus.approved),
                        child: const Text('Approved'),
                      ),
                      OutlinedButton(
                        onPressed: () => notifier.setStatus(
                          DriverStatus.rejected,
                          rejectionReason: 'Document mismatch or expired file (mock)',
                        ),
                        child: const Text('Rejected'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Stepper(
              currentStep: step,
              onStepContinue: () => setState(() => step = (step + 1).clamp(0, 3)),
              onStepCancel: () => setState(() => step = (step - 1).clamp(0, 3)),
              onStepTapped: (i) => setState(() => step = i),
              controlsBuilder: (context, details) {
                return Wrap(
                  spacing: 8,
                  children: [
                    FilledButton(
                      onPressed: details.onStepContinue,
                      child: Text(step == 3 ? 'Finish' : 'Continue'),
                    ),
                    OutlinedButton(
                      onPressed: details.onStepCancel,
                      child: const Text('Back'),
                    ),
                  ],
                );
              },
              steps: const [
                Step(
                  title: Text('Personal Information'),
                  content: Text('Identity, contact, and approved-driver details.'),
                ),
                Step(
                  title: Text('Vehicle Information'),
                  content: Text(
                    'Vehicle type, plate, and operational compliance attributes.',
                  ),
                ),
                Step(
                  title: Text('Selfie Verification'),
                  content: Text(
                    'Real-time selfie capture and face match validation flow.',
                  ),
                ),
                Step(
                  title: Text('Document Checklist'),
                  content: Text('Upload required documents and resolve rejections.'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton.icon(
              onPressed: () => context.go('/registration/documents'),
              icon: const Icon(Icons.upload_file),
              label: const Text('Open document upload checklist'),
            ),
          ),
        ],
      ),
    );
  }
}
