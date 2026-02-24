// import 'package:flutter/material.dart';
// import '../models/driver.dart';

// class StatusBadge extends StatelessWidget {
//   final DriverStatus status;
//   const StatusBadge({super.key, required this.status});

//   @override
//   Widget build(BuildContext context) {
//     final (label, color) = switch (status) {
//       DriverStatus.pending => ('Pending', Colors.orange),
//       DriverStatus.underVerification => ('Under verification', Colors.blue),
//       DriverStatus.approved => ('Approved', Colors.green),
//       DriverStatus.rejected => ('Rejected', Colors.red),
//       DriverStatus.suspended => ('Suspended', Colors.redAccent),
//     };

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
//       decoration: BoxDecoration(
//         color: color.withOpacity(0.12),
//         borderRadius: BorderRadius.circular(999),
//         border: Border.all(color: color.withOpacity(0.3)),
//       ),
//       child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600)),
//     );
//   }
// }

import 'package:flutter/material.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink(); // placeholder banner
  }
}