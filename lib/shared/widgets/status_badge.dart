import 'package:flutter/material.dart';
import '../models/driver.dart';

class StatusBadge extends StatelessWidget {
  final DriverStatus status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final (label, color) = switch (status) {
      DriverStatus.none => ('Sin estado', Colors.grey),
      DriverStatus.pending => ('Pendiente', Colors.orange),
      DriverStatus.underVerification => ('En verificación', Colors.blue),
      DriverStatus.approved => ('Aprobado', Colors.green),
      DriverStatus.rejected => ('Rechazado', Colors.red),
      DriverStatus.suspended => ('Suspendido', Colors.redAccent),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: primary.withValues(alpha: 0.28)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 10, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
