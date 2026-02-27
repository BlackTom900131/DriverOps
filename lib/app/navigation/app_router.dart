import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/state/auth_state.dart';
import '../../features/auth/ui/login_details_screen.dart';
import '../../features/auth/ui/login_screen.dart';
import '../../features/delivery/ui/delivery_screen.dart';
import '../../features/delivery/ui/failed_delivery_screen.dart';
import '../../features/delivery/ui/pod_screen.dart';
import '../../features/document/ui/document_screen.dart';
import '../../features/messages/ui/messages_screen.dart';
import '../../features/offline_queue/ui/offline_queue_screen.dart';
import '../../features/pickup/ui/pickup_screen.dart';
import '../../features/profile/ui/profile_screen.dart';
import '../../features/qr/ui/qr_screen.dart';
import '../../features/registration/ui/document_upload_screen.dart';
import '../../features/registration/ui/registration_stepper_screen.dart';
import '../../features/routes/ui/route_map_screen.dart';
import '../../features/routes/ui/routes_list_screen.dart';
import '../../features/routes/ui/stop_detail_screen.dart';
import '../../features/security/ui/security_screen.dart';
import '../../features/status/ui/status_screen.dart';
import '../../features/vehicle/ui/vehicle_screen.dart';
import '../../features/workday/ui/home_screen.dart';
import '../../features/workday/ui/start_workday_screen.dart';
import '../../shared/models/driver.dart';
import 'app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authStateProvider.notifier).stream,
    ),
    redirect: (context, state) {
      final location = state.matchedLocation;
      final loggingIn = AppRoutes.isInSection(location, AppRoutes.login);
      final registering = AppRoutes.isInSection(
        location,
        AppRoutes.registration,
      );

      if (!auth.isLoggedIn) {
        return (loggingIn || registering) ? null : AppRoutes.login;
      }

      if (loggingIn) return AppRoutes.home;

      if (auth.driverStatus != DriverStatus.approved) {
        final onHome = location == AppRoutes.home;
        final onRoutes = AppRoutes.isInSection(location, AppRoutes.homeRoutes);
        final onQr = AppRoutes.isInSection(location, AppRoutes.homeQr);
        final onStatus = location == AppRoutes.homeStatus;
        final onProfile = AppRoutes.isInSection(location, AppRoutes.homeProfile);
        final onVehicle = AppRoutes.isInSection(location, AppRoutes.homeVehicle);
        final onDocuments = AppRoutes.isInSection(
          location,
          AppRoutes.homeDocuments,
        );
        final onSecurity = AppRoutes.isInSection(
          location,
          AppRoutes.homeSecurity,
        );
        final onMessages = AppRoutes.isInSection(
          location,
          AppRoutes.homeMessages,
        );
        if (!registering &&
            !onHome &&
            !onRoutes &&
            !onQr &&
            !onStatus &&
            !onProfile &&
            !onVehicle &&
            !onDocuments &&
            !onSecurity &&
            !onMessages) {
          return AppRoutes.homeStatus;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (_, _) => const LoginScreen(),
        routes: [
          GoRoute(path: 'details', builder: (_, _) => const LoginDetailsScreen()),
        ],
      ),
      GoRoute(
        path: AppRoutes.registration,
        builder: (_, _) => const RegistrationStepperScreen(),
        routes: [
          GoRoute(path: 'documents', builder: (_, _) => const DocumentUploadScreen()),
        ],
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, _) => const HomeScreen(),
        routes: [
          GoRoute(path: 'status', builder: (_, _) => const StatusScreen()),
          GoRoute(
            path: 'start-workday',
            builder: (_, _) => const StartWorkdayScreen(),
          ),
          GoRoute(
            path: 'routes',
            builder: (_, _) => const RoutesListScreen(),
            routes: [
              GoRoute(
                path: ':routeId/map',
                builder: (_, s) =>
                    RouteMapScreen(routeId: s.pathParameters['routeId']!),
              ),
              GoRoute(
                path: ':routeId/stops/:stopId',
                builder: (_, s) => StopDetailScreen(
                  routeId: s.pathParameters['routeId']!,
                  stopId: s.pathParameters['stopId']!,
                ),
                routes: [
                  GoRoute(
                    path: 'pickup',
                    builder: (_, s) => PickupScreen(
                      routeId: s.pathParameters['routeId']!,
                      stopId: s.pathParameters['stopId']!,
                    ),
                  ),
                  GoRoute(
                    path: 'delivery',
                    builder: (_, s) => DeliveryScreen(
                      routeId: s.pathParameters['routeId']!,
                      stopId: s.pathParameters['stopId']!,
                    ),
                    routes: [
                      GoRoute(
                        path: 'pod',
                        builder: (_, s) => PodScreen(
                          routeId: s.pathParameters['routeId']!,
                          stopId: s.pathParameters['stopId']!,
                        ),
                      ),
                      GoRoute(
                        path: 'failed',
                        builder: (_, s) => FailedDeliveryScreen(
                          routeId: s.pathParameters['routeId']!,
                          stopId: s.pathParameters['stopId']!,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: 'offline-queue',
            builder: (_, _) => const OfflineQueueScreen(),
          ),
          GoRoute(path: 'profile', builder: (_, _) => const ProfileScreen()),
          GoRoute(path: 'vehicle', builder: (_, _) => const VehicleScreen()),
          GoRoute(path: 'documents', builder: (_, _) => const DocumentScreen()),
          GoRoute(path: 'security', builder: (_, _) => const SecurityScreen()),
          GoRoute(path: 'messages', builder: (_, _) => const MessagesScreen()),
          GoRoute(path: 'qr', builder: (_, _) => const QrScreen()),
        ],
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text(state.error.toString())),
    ),
  );
});

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
  }

  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
