enum RouteType { pickup, delivery, mixed }

enum RouteStatus { pending, inProgress, completed }

enum StopStatus { pending, inProgress, done }

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
}

class RouteStop {
  final String id;
  final String customerName;
  final String address;
  final StopStatus status;
  final double? latitude;
  final double? longitude;

  const RouteStop({
    required this.id,
    required this.customerName,
    required this.address,
    required this.status,
    this.latitude,
    this.longitude,
  });
}
