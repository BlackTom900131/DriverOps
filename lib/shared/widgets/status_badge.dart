import 'package:flutter/material.dart';

enum StatusBadgeType { success, warning, error, info }

class StatusBadge extends StatelessWidget {
  final String text;
  final StatusBadgeType type;

  const StatusBadge({
    super.key,
    required this.text,
    this.type = StatusBadgeType.info,
  });

  Color _color(BuildContext context) {
    switch (type) {
      case StatusBadgeType.success:
        return Colors.green;
      case StatusBadgeType.warning:
        return Colors.orange;
      case StatusBadgeType.error:
        return Colors.red;
      case StatusBadgeType.info:
      default:
        return Theme.of(context).colorScheme.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = _color(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.withOpacity(0.12),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.withOpacity(0.2)),
      ),
      child: Text(
        text,
        style: TextStyle(color: c, fontWeight: FontWeight.w600, fontSize: 12),
      ),
    );
  }
}
