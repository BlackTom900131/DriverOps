/// Status of a driver route.
enum RouteStatus {
  planned,
  inProgress,
  completed,
  cancelled,
}

/// Represents a single stop on a route.
class RouteStop {
  const RouteStop({
    required this.id,
    required this.name,
    this.address,
    this.sequenceIndex = 0,
    this.arrivedAt,
    this.completedAt,
  });

  final String id;
  final String name;
  final String? address;
  final int sequenceIndex;
  final DateTime? arrivedAt;
  final DateTime? completedAt;

  RouteStop copyWith({
    String? id,
    String? name,
    String? address,
    int? sequenceIndex,
    DateTime? arrivedAt,
    DateTime? completedAt,
  }) {
    return RouteStop(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      sequenceIndex: sequenceIndex ?? this.sequenceIndex,
      arrivedAt: arrivedAt ?? this.arrivedAt,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}

/// Represents a single route (e.g. delivery or driving route).
class RouteRecord {
  const RouteRecord({
    required this.id,
    required this.name,
    this.origin,
    this.destination,
    this.status = RouteStatus.planned,
    this.scheduledAt,
    this.completedAt,
    this.stops = const [],
  });

  final String id;
  final String name;
  final String? origin;
  final String? destination;
  final RouteStatus status;
  final DateTime? scheduledAt;
  final DateTime? completedAt;
  final List<RouteStop> stops;

  RouteRecord copyWith({
    String? id,
    String? name,
    String? origin,
    String? destination,
    RouteStatus? status,
    DateTime? scheduledAt,
    DateTime? completedAt,
    List<RouteStop>? stops,
  }) {
    return RouteRecord(
      id: id ?? this.id,
      name: name ?? this.name,
      origin: origin ?? this.origin,
      destination: destination ?? this.destination,
      status: status ?? this.status,
      scheduledAt: scheduledAt ?? this.scheduledAt,
      completedAt: completedAt ?? this.completedAt,
      stops: stops ?? this.stops,
    );
  }
}

/// Holds the routes feature state (list of routes + loading/error).
class RoutesState {
  const RoutesState({
    this.routes = const [],
    this.selectedRouteId,
    this.isLoading = false,
    this.error,
  });

  final List<RouteRecord> routes;
  final String? selectedRouteId;
  final bool isLoading;
  final String? error;

  RoutesState copyWith({
    List<RouteRecord>? routes,
    String? selectedRouteId,
    bool? isLoading,
    String? error,
  }) {
    return RoutesState(
      routes: routes ?? this.routes,
      selectedRouteId: selectedRouteId ?? this.selectedRouteId,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}
