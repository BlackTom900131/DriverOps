import 'package:flutter/material.dart';

class OfflineBanner extends StatelessWidget {
  final bool offline;
  final String message;

  const OfflineBanner({
    super.key,
    required this.offline,
    this.message = 'You are offline',
  });

  @override
  Widget build(BuildContext context) {
    if (!offline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      color: Colors.red.shade700,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: Row(
        children: [
          const Icon(Icons.signal_wifi_off, color: Colors.white, size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
