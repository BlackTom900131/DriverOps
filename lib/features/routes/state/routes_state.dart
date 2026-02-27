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

  bool canOpenStop(String routeId, String stopId) {
    final route = byId(routeId);
    if (route == null) return false;
    final index = route.stops.indexWhere((s) => s.id == stopId);
    if (index == -1) return false;
    return route.stops.take(index).every((s) => s.status == StopStatus.done);
  }

  String? firstBlockedStopReason(String routeId, String stopId) {
    final route = byId(routeId);
    if (route == null) return 'Route not found.';
    final index = route.stops.indexWhere((s) => s.id == stopId);
    if (index == -1) return 'Stop not found.';
    for (var i = 0; i < index; i++) {
      if (route.stops[i].status != StopStatus.done) {
        return 'Complete stop ${route.stops[i].id} first to preserve ordered execution.';
      }
    }
    return null;
  }
}

final routesProvider = StateNotifierProvider<RoutesNotifier, RoutesState>((
  ref,
) {
  return RoutesNotifier();
});
