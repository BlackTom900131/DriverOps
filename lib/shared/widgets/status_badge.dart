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
      DriverStatus.none => ('No status', Colors.grey),
      DriverStatus.pending => ('Pending', Colors.orange),
      DriverStatus.underVerification => ('Under verification', Colors.blue),
      DriverStatus.approved => ('Approved', Colors.green),
      DriverStatus.rejected => ('Rejected', Colors.red),
      DriverStatus.suspended => ('Suspended', Colors.redAccent),
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
