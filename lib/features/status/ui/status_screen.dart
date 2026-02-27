import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/driver.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../auth/state/auth_state.dart';

class StatusScreen extends ConsumerWidget {
  const StatusScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authStateProvider);
    final status = auth.driverStatus;
    // status = DriverStatus.none; // For testing, remove in production
    final color = _colorFor(status);

    return AppScaffold(
      title: 'Estado del conductor',
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_iconFor(status), size: 120, color: color),
                  const SizedBox(height: 16),
                  Text(
                    _labelFor(status),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _labelFor(DriverStatus status) {
    return switch (status) {
      DriverStatus.none => 'No se detectó ninguna acción.',
      DriverStatus.pending => 'Su solicitud está pendiente de revisión.',
      DriverStatus.underVerification => 'Su cuenta está en verificación.',
      DriverStatus.approved => 'Ha sido aprobado.',
      DriverStatus.rejected => 'Ha sido rechazado.',
      DriverStatus.suspended => 'Su cuenta ha sido suspendida.',
    };
  }

  IconData _iconFor(DriverStatus status) {
    return switch (status) {
      DriverStatus.none => Icons.info_outline,
      DriverStatus.pending => Icons.hourglass_top_rounded,
      DriverStatus.underVerification => Icons.fact_check_outlined,
      DriverStatus.approved => Icons.check_circle_outlined,
      DriverStatus.rejected => Icons.cancel_outlined,
      DriverStatus.suspended => Icons.pause_circle_outline_rounded,
    };
  }

  Color _colorFor(DriverStatus status) {
    return switch (status) {
      DriverStatus.none => const Color.fromARGB(255, 143, 250, 143),
      DriverStatus.pending => const Color(0xFFFF9F0A),
      DriverStatus.underVerification => const Color(0xFF0A84FF),
      DriverStatus.approved => const Color(0xFF34C759),
      DriverStatus.rejected => const Color(0xFFFF3B30),
      DriverStatus.suspended => const Color(0xFF8E8E93),
    };
  }
}
