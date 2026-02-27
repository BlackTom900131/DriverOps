import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/route_models.dart';
import '../../../shared/extensions/iterable_extensions.dart';

class RoutesState {
  final List<DriverRoute> routes;
  final String? selectedRouteId;

  const RoutesState({required this.routes, this.selectedRouteId});

  RoutesState copyWith({List<DriverRoute>? routes, String? selectedRouteId}) {
    return RoutesState(
      routes: routes ?? this.routes,
      selectedRouteId: selectedRouteId ?? this.selectedRouteId,
    );
  }
}

class RoutesNotifier extends StateNotifier<RoutesState> {
  RoutesNotifier()
    : super(
        RoutesState(
          routes: [
            DriverRoute(
              id: 'R-1001',
              type: RouteType.mixed,
              status: RouteStatus.pending,
              stops: const [
                RouteStop(
                  id: 'S-1',
                  customerName: 'Salesforce Tower',
                  customerContact: '+1 415-555-0101',
                  address: '415 Mission St, San Francisco, CA 94105',
                  expectedPackages: 14,
                  type: StopType.pickup,
                  status: StopStatus.pending,
                  latitude: 37.7897,
                  longitude: -122.3969,
                ),
                RouteStop(
                  id: 'S-2',
                  customerName: 'Oracle Park',
                  customerContact: '+1 415-555-0102',
                  address: '24 Willie Mays Plaza, San Francisco, CA 94107',
                  expectedPackages: 9,
                  type: StopType.delivery,
                  status: StopStatus.pending,
                  latitude: 37.7786,
                  longitude: -122.3893,
                ),
                RouteStop(
                  id: 'S-3',
                  customerName: 'Ferry Building',
                  customerContact: '+1 415-555-0103',
                  address: '1 Ferry Building, San Francisco, CA 94111',
                  expectedPackages: 6,
                  type: StopType.mixed,
                  status: StopStatus.pending,
                  latitude: 37.7955,
                  longitude: -122.3937,
                ),
              ],
            ),
            DriverRoute(
              id: 'R-1002',
              type: RouteType.delivery,
              status: RouteStatus.inProgress,
              stops: const [
                RouteStop(
                  id: 'S-10',
                  customerName: 'Pier 39',
                  customerContact: '+1 415-555-0110',
                  address:
                      'Beach St & The Embarcadero, San Francisco, CA 94133',
                  expectedPackages: 11,
                  type: StopType.delivery,
                  status: StopStatus.inProgress,
                  latitude: 37.8087,
                  longitude: -122.4098,
                ),
                RouteStop(
                  id: 'S-11',
                  customerName: 'Lombard Street',
                  customerContact: '+1 415-555-0111',
                  address: '1000 Lombard St, San Francisco, CA 94109',
                  expectedPackages: 5,
                  type: StopType.delivery,
                  status: StopStatus.pending,
                  latitude: 37.8021,
                  longitude: -122.4187,
                ),
              ],
            ),
          ],
          selectedRouteId: 'R-1001',
        ),
      );

  void selectRoute(String? routeId) {
    if (routeId == null) return;
    if (state.routes.any((r) => r.id == routeId)) {
      state = state.copyWith(selectedRouteId: routeId);
    }
  }

  DriverRoute? byId(String id) =>
      state.routes.where((r) => r.id == id).firstOrNull;

  RouteStop? stopById(String routeId, String stopId) {
    final route = byId(routeId);
    if (route == null) return null;
    return route.stops.where((s) => s.id == stopId).firstOrNull;
  }

  bool canOpenStop(String routeId, String stopId) {
    final route = byId(routeId);
    if (route == null) return false;
    final index = route.stops.indexWhere((s) => s.id == stopId);
    if (index == -1) return false;
    return route.stops.take(index).every((s) => s.status == StopStatus.done);
  }

  String? firstBlockedStopReason(String routeId, String stopId) {
    final route = byId(routeId);
    if (route == null) return 'route_not_found';
    final index = route.stops.indexWhere((s) => s.id == stopId);
    if (index == -1) return 'stop_not_found';
    for (var i = 0; i < index; i++) {
      if (route.stops[i].status != StopStatus.done) {
        return 'complete_first:${route.stops[i].id}';
      }
    }
    return null;
  }

  void markStopArrived(String routeId, String stopId) {
    _updateStopStatus(
      routeId: routeId,
      stopId: stopId,
      nextStatus: StopStatus.inProgress,
      updateWhen: (status) => status == StopStatus.pending,
    );
  }

  void markPickupCompleted(String routeId, String stopId) {
    _updateStopStatus(
      routeId: routeId,
      stopId: stopId,
      nextStatus: StopStatus.done,
      updateWhen: (status) => status != StopStatus.done,
    );
  }

  void _updateStopStatus({
    required String routeId,
    required String stopId,
    required StopStatus nextStatus,
    required bool Function(StopStatus status) updateWhen,
  }) {
    final routes = state.routes;
    final routeIndex = routes.indexWhere((r) => r.id == routeId);
    if (routeIndex == -1) return;

    final route = routes[routeIndex];
    final stopIndex = route.stops.indexWhere((s) => s.id == stopId);
    if (stopIndex == -1) return;

    final stop = route.stops[stopIndex];
    if (!updateWhen(stop.status)) return;

    final updatedStops = List<RouteStop>.from(route.stops);
    updatedStops[stopIndex] = stop.copyWith(status: nextStatus);

    final updatedRoute = route.copyWith(
      stops: updatedStops,
      status: _computeRouteStatus(updatedStops),
    );
    final updatedRoutes = List<DriverRoute>.from(routes);
    updatedRoutes[routeIndex] = updatedRoute;
    state = state.copyWith(routes: updatedRoutes);
  }

  RouteStatus _computeRouteStatus(List<RouteStop> stops) {
    if (stops.isNotEmpty && stops.every((s) => s.status == StopStatus.done)) {
      return RouteStatus.completed;
    }
    if (stops.any((s) => s.status != StopStatus.pending)) {
      return RouteStatus.inProgress;
    }
    return RouteStatus.pending;
  }
}

final routesProvider = StateNotifierProvider<RoutesNotifier, RoutesState>((
  ref,
) {
  return RoutesNotifier();
});
