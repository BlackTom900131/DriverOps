import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/state/auth_state.dart';
import '../state/workday_state.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../../shared/models/driver.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    final workday = ref.watch(workdayProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final status = _statusLabel(auth.driverStatus);
    final workdayText = workday.started ? 'Active now' : 'Not started';

    return AppScaffold(
      title: 'Driver Operations',
      actions: [
        IconButton(
          tooltip: 'Profile',
          onPressed: () => context.go('/home/profile'),
          icon: const Icon(Icons.person_2_outlined),
        ),
        IconButton(
          tooltip: 'Offline Queue',
          onPressed: () => context.go('/home/offline-queue'),
          icon: const Icon(Icons.cloud_sync_outlined),
        ),
      ],
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 16),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(26),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF0A84FF), Color(0xFF4DA2FF)],
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3A0A84FF),
                  blurRadius: 22,
                  offset: Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: Colors.white.withValues(alpha: 0.18),
                  ),
                  child: Text(
                    status,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Welcome back,\n${auth.driverName}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 28,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Workday status: $workdayText',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                if (workday.startedAt != null)
                  Text(
                    'Started at ${workday.startedAt}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: FilledButton(
                        onPressed: workday.started
                            ? null
                            : () => context.go('/home/start-workday'),
                        style: FilledButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF0A84FF),
                        ),
                        child: Text(workday.started ? 'Workday Active' : 'Start Workday'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => context.go('/home/routes'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white70),
                        ),
                        child: const Text('View Routes'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  _QuickActionChip(
                    icon: Icons.badge_outlined,
                    label: 'Registration',
                    onTap: () => context.go('/registration'),
                  ),
                  _QuickActionChip(
                    icon: Icons.route_outlined,
                    label: 'Routes',
                    onTap: () => context.go('/home/routes'),
                  ),
                  _QuickActionChip(
                    icon: Icons.inventory_2_outlined,
                    label: 'Pickup',
                    onTap: () => context.go('/home/routes'),
                  ),
                  _QuickActionChip(
                    icon: Icons.check_circle_outline,
                    label: 'Delivery',
                    onTap: () => context.go('/home/routes'),
                  ),
                  _QuickActionChip(
                    icon: Icons.cloud_sync_outlined,
                    label: 'Offline Queue',
                    onTap: () => context.go('/home/offline-queue'),
                  ),
                  _QuickActionChip(
                    icon: Icons.person_outline,
                    label: 'Profile',
                    onTap: () => context.go('/home/profile'),
                  ),
                ],
              ),
            ),
          ),
          _MilestoneCard(
            icon: Icons.lock_outline,
            title: 'Foundation & Secure Access',
            subtitle: 'Token auth, biometrics, approved-driver access, session control.',
            accent: colorScheme.primary,
          ),
          _MilestoneCard(
            icon: Icons.assignment_outlined,
            title: 'Registration & Compliance',
            subtitle: 'Multi-step onboarding, uploads, verification statuses, expiration alerts.',
            accent: const Color(0xFF34C759),
          ),
          _MilestoneCard(
            icon: Icons.alt_route_outlined,
            title: 'Workday & Routes',
            subtitle: 'Start confirmation, route detail, ordered stops, navigation checks.',
            accent: const Color(0xFFFF9F0A),
          ),
          _MilestoneCard(
            icon: Icons.qr_code_scanner_outlined,
            title: 'Pickup & Load Validation',
            subtitle: 'Scan, duplicate prevention, mismatch alerts, load confirmation logs.',
            accent: const Color(0xFF5E5CE6),
          ),
          _MilestoneCard(
            icon: Icons.local_shipping_outlined,
            title: 'Delivery, POD & Incidents',
            subtitle: 'Mandatory scan, POD evidence, failed reasons, incident workflow.',
            accent: const Color(0xFFFF375F),
          ),
          _MilestoneCard(
            icon: Icons.cloud_done_outlined,
            title: 'Offline Sync & Security',
            subtitle: 'Encrypted queue, automatic sync, conflict handling, push and HTTPS.',
            accent: const Color(0xFF30B0C7),
          ),
        ],
      ),
    );
  }

  String _statusLabel(DriverStatus status) {
    return switch (status) {
      DriverStatus.none => 'No status',
      DriverStatus.pending => 'Pending verification',
      DriverStatus.underVerification => 'Under verification',
      DriverStatus.approved => 'Approved driver',
      DriverStatus.rejected => 'Rejected',
      DriverStatus.suspended => 'Suspended',
    };
  }
}

class _QuickActionChip extends StatelessWidget {
  const _QuickActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18, color: Theme.of(context).colorScheme.primary),
      label: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
      onPressed: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13)),
      side: BorderSide(color: Theme.of(context).colorScheme.outline),
      backgroundColor: Colors.white,
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }
}

class _MilestoneCard extends StatelessWidget {
  const _MilestoneCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: accent.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: accent),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle),
        ),
      ),
    );
  }
}
