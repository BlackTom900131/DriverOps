import 'dart:convert';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PickupScanPayload {
  final String driverId;
  final String routeId;
  final String stopId;
  final String scannedCode;
  final DateTime scannedAt;
  final double? latitude;
  final double? longitude;

  const PickupScanPayload({
    required this.driverId,
    required this.routeId,
    required this.stopId,
    required this.scannedCode,
    required this.scannedAt,
    required this.latitude,
    required this.longitude,
  });

  Map<String, dynamic> toJson() {
    return {
      'driverId': driverId,
      'routeId': routeId,
      'stopId': stopId,
      'packageStatus': 'Picked Up',
      'stopStatus': 'done',
      'scannedCode': scannedCode,
      'dateTime': scannedAt.toIso8601String(),
      'gpsLocation': {'latitude': latitude, 'longitude': longitude},
    };
  }
}

class PickupSyncService {
  static final Uri _endpoint = Uri.parse(
    'https://example.com/api/pickups/confirm',
  );

  Future<void> uploadPickupScan(PickupScanPayload payload) async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 8);
    try {
      final request = await client.postUrl(_endpoint);
      request.headers.contentType = ContentType.json;
      request.write(jsonEncode(payload.toJson()));
      final response = await request.close();
      if (response.statusCode < 200 || response.statusCode >= 300) {
        throw HttpException(
          'La subida de recogida falló con estado ${response.statusCode}',
          uri: _endpoint,
        );
      }
    } finally {
      client.close(force: true);
    }
  }
}

final pickupSyncServiceProvider = Provider<PickupSyncService>((ref) {
  return PickupSyncService();
});
