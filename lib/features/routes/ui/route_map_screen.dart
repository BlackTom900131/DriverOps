import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../state/routes_state.dart';

class RouteMapScreen extends ConsumerWidget {
  final String routeId;

  const RouteMapScreen({super.key, required this.routeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref
        .watch(routesProvider)
        .routes
        .where((r) => r.id == routeId)
        .firstOrNull;

    if (route == null) {
      return AppScaffold(
        title: 'Route Map',
        body: const Center(child: Text('Route not found.')),
      );
    }

    final stopsWithCoordinates = route.stops
        .where((s) => s.latitude != null && s.longitude != null)
        .toList();
    if (stopsWithCoordinates.isEmpty) {
      return AppScaffold(
        title: 'Route Map',
        body: const Center(
          child: Text('No coordinate data available for this route.'),
        ),
      );
    }

    final first = stopsWithCoordinates.first;
    final initialPosition = CameraPosition(
      target: LatLng(first.latitude!, first.longitude!),
      zoom: 12.5,
    );

    final markers = stopsWithCoordinates.map((stop) {
      return Marker(
        markerId: MarkerId(stop.id),
        position: LatLng(stop.latitude!, stop.longitude!),
        infoWindow: InfoWindow(
          title: '${stop.id} - ${stop.customerName}',
          snippet: stop.address,
        ),
      );
    }).toSet();

    final polylinePoints = stopsWithCoordinates
        .map((s) => LatLng(s.latitude!, s.longitude!))
        .toList();

    final polylines = polylinePoints.length > 1
        ? {
            Polyline(
              polylineId: const PolylineId('route-path'),
              points: polylinePoints,
              width: 5,
              color: Theme.of(context).colorScheme.primary,
            ),
          }
        : <Polyline>{};

    return AppScaffold(
      title: 'Route Map $routeId',
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              initialCameraPosition: initialPosition,
              markers: markers,
              polylines: polylines,
              mapToolbarEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: true,
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  const Icon(Icons.location_on_outlined),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '${route.stops.length} stops | ${stopsWithCoordinates.length} with coordinates',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

extension _FirstOrNull<T> on Iterable<T> {
  T? get firstOrNull => isEmpty ? null : first;
}
