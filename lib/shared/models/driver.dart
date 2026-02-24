enum DriverStatus { pending, underVerification, approved, rejected, suspended }

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
}
