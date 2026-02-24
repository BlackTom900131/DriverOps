import 'dart:convert';

enum DriverStatus {
  none,
  pending,
  underVerification,
  approved,
  rejected,
  suspended,
}

class Driver {
  final String id;
  final String name;
  final String email;
  final DriverStatus status;
  final String? rejectionReason;

  const Driver({
    required this.id,
    required this.name,
    required this.email,
    required this.status,
    this.rejectionReason,
  });

  Driver copyWith({
    String? id,
    String? name,
    String? email,
    DriverStatus? status,
    String? rejectionReason,
  }) {
    return Driver(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      status: status ?? this.status,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'status': status.name,
      'rejectionReason': rejectionReason,
    };
  }

  factory Driver.fromMap(Map<String, dynamic> map) {
    return Driver(
      id: map['id'] as String? ?? '',
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      status: DriverStatus.values.firstWhere(
        (s) => s.name == map['status'],
        orElse: () => DriverStatus.pending,
      ),
      rejectionReason: map['rejectionReason'] as String?,
    );
  }

  static String listToJson(List<Driver> drivers) {
    return jsonEncode(drivers.map((d) => d.toMap()).toList());
  }

  static List<Driver> listFromJson(String? raw) {
    if (raw == null || raw.trim().isEmpty) return [];
    final decoded = jsonDecode(raw);
    if (decoded is! List) return [];
    return decoded
        .whereType<Map>()
        .map((m) => Driver.fromMap(Map<String, dynamic>.from(m)))
        .toList();
  }
}

extension DriverStatusX on DriverStatus {
  String get label {
    return switch (this) {
      DriverStatus.none => 'No action.',
      DriverStatus.pending => 'Pending',
      DriverStatus.underVerification => 'Under Verification',
      DriverStatus.approved => 'Approved',
      DriverStatus.rejected => 'Rejected',
      DriverStatus.suspended => 'Suspended',
    };
  }
}
