import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../features/auth/state/auth_state.dart';
import '../shared/models/driver.dart';
import '../features/auth/ui/login_screen.dart';
import '../features/registration/ui/registration_stepper_screen.dart';
import '../features/workday/ui/home_screen.dart';
import '../features/workday/ui/start_workday_screen.dart';
import '../features/routes/ui/routes_list_screen.dart';
import '../features/routes/ui/route_detail_screen.dart';
import '../features/routes/ui/stop_detail_screen.dart';
import '../features/pickup/ui/pickup_screen.dart';
import '../features/delivery/ui/delivery_screen.dart';
import '../features/delivery/ui/pod_screen.dart';
import '../features/delivery/ui/failed_delivery_screen.dart';
import '../features/offline_queue/ui/offline_queue_screen.dart';
import '../features/profile/ui/profile_screen.dart';
import '../features/registration/ui/document_upload_screen.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(
      ref.watch(authStateProvider.notifier).stream,
    ),
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == '/login';

      // Not logged in -> force login
      if (!auth.isLoggedIn) {
        return loggingIn ? null : '/login';
      }

      // Logged in -> prevent going back to login
      if (loggingIn) return '/home';

      // Driver status gate: only Approved can operate
      if (auth.driverStatus != DriverStatus.approved) {
        // Allow registration screen even if not approved.
        final onRegistration = state.matchedLocation.startsWith(
          '/registration',
        );
        if (!onRegistration) return '/registration';
      }

      return null;
    },
    routes: [
      GoRoute(path: '/login', builder: (_, _) => const LoginScreen()),
      GoRoute(
        path: '/registration',
        builder: (_, _) => const RegistrationStepperScreen(),
        routes: [
          GoRoute(
            path: 'documents',
            builder: (_, _) => const DocumentUploadScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/home',
        builder: (_, _) => const HomeScreen(),
        routes: [
          GoRoute(
            path: 'start-workday',
            builder: (_, _) => const StartWorkdayScreen(),
          ),
          GoRoute(
            path: 'routes',
            builder: (_, _) => const RoutesListScreen(),
            routes: [
              GoRoute(
                path: ':routeId',
                builder: (_, s) =>
                    RouteDetailScreen(routeId: s.pathParameters['routeId']!),
                routes: [
                  GoRoute(
                    path: 'stops/:stopId',
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
            ],
          ),
          GoRoute(
            path: 'offline-queue',
            builder: (_, _) => const OfflineQueueScreen(),
          ),
          GoRoute(path: 'profile', builder: (_, _) => const ProfileScreen()),
        ],
      ),
    ],
    errorBuilder: (_, state) => Scaffold(
      appBar: AppBar(title: const Text('Error')),
      body: Center(child: Text(state.error.toString())),
    ),
  );
});

/// Simple GoRouter refresh helper (Riverpod doesn't expose Listenable by default)
// class GoRouterRefreshStream extends ChangeNotifier {
//   GoRouterRefreshStream(Stream<dynamic> stream) {
//     _sub = stream.asBroadcastStream().listen((_) => notifyListeners());
//   }
//   late final StreamSubscription<dynamic> _sub;
//   @override
//   void dispose() {
//     _sub.cancel();
//     super.dispose();
//   }
// }
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
