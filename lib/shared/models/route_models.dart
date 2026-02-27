enum RouteType { pickup, delivery, mixed }

enum RouteStatus { pending, inProgress, completed }

enum StopStatus { pending, inProgress, done }

enum StopType { pickup, delivery, mixed }

class DriverRoute {
  final String id;
  final RouteType type;
  final RouteStatus status;
  final List<RouteStop> stops;

  const DriverRoute({
    required this.id,
    required this.type,
    required this.status,
    required this.stops,
  });

  DriverRoute copyWith({
    String? id,
    RouteType? type,
    RouteStatus? status,
    List<RouteStop>? stops,
  }) {
    return DriverRoute(
      id: id ?? this.id,
      type: type ?? this.type,
      status: status ?? this.status,
      stops: stops ?? this.stops,
    );
  }
}

class RouteStop {
  final String id;
  final String customerName;
  final String customerContact;
  final String address;
  final int expectedPackages;
  final StopType type;
  final StopStatus status;
  final double? latitude;
  final double? longitude;

  const RouteStop({
    required this.id,
    required this.customerName,
    required this.customerContact,
    required this.address,
    required this.expectedPackages,
    required this.type,
    required this.status,
    this.latitude,
    this.longitude,
  });

  RouteStop copyWith({
    String? id,
    String? customerName,
    String? customerContact,
    String? address,
    int? expectedPackages,
    StopType? type,
    StopStatus? status,
    double? latitude,
    double? longitude,
  }) {
    return RouteStop(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerContact: customerContact ?? this.customerContact,
      address: address ?? this.address,
      expectedPackages: expectedPackages ?? this.expectedPackages,
      type: type ?? this.type,
      status: status ?? this.status,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
