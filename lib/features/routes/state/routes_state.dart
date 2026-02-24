import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/route_models.dart';

class RoutesState {
  final List<DriverRoute> routes;
  const RoutesState({required this.routes});
}

class RoutesNotifier extends StateNotifier<RoutesState> {
  RoutesNotifier()
      : super(RoutesState(routes: [
          DriverRoute(
            id: 'R-1001',
            type: RouteType.mixed,
            status: RouteStatus.pending,
            stops: const [
              RouteStop(id: 'S-1', customerName: 'Alice', address: 'Street 1', status: StopStatus.pending),
              RouteStop(id: 'S-2', customerName: 'Bob', address: 'Street 2', status: StopStatus.pending),
              RouteStop(id: 'S-3', customerName: 'Carol', address: 'Street 3', status: StopStatus.pending),
            ],
          ),
          DriverRoute(
            id: 'R-1002',
            type: RouteType.delivery,
            status: RouteStatus.inProgress,
            stops: const [
              RouteStop(id: 'S-10', customerName: 'Dan', address: 'Street 10', status: StopStatus.inProgress),
              RouteStop(id: 'S-11', customerName: 'Eve', address: 'Street 11', status: StopStatus.pending),
            ],
          ),
        ]));

  DriverRoute? byId(String id) => state.routes.where((r) => r.id == id).cast<DriverRoute?>().firstOrNull;
}

final routesProvider = StateNotifierProvider<RoutesNotifier, RoutesState>((ref) {
  return RoutesNotifier();
});

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
