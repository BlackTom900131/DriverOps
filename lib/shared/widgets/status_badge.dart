import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../models/driver.dart';

class StatusBadge extends StatelessWidget {
  final DriverStatus status;
  const StatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;
    final (label, color) = switch (status) {
      DriverStatus.none => (tr('status.badge_none'), Colors.grey),
      DriverStatus.pending => (tr('status.badge_pending'), Colors.orange),
      DriverStatus.underVerification => (tr('status.badge_under_verification'), Colors.blue),
      DriverStatus.approved => (tr('status.badge_approved'), Colors.green),
      DriverStatus.rejected => (tr('status.badge_rejected'), Colors.red),
      DriverStatus.suspended => (tr('status.badge_suspended'), Colors.redAccent),
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
