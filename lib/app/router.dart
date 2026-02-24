import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const String home = '/';
  static const String auth = '/auth';
  static const String registration = '/registration';
  static const String profile = '/profile';
  static const String workday = '/workday';
  static const String routes = '/routes';
  static const String pickup = '/pickup';
  static const String delivery = '/delivery';
  static const String offlineQueue = '/offline_queue';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) =>
          Scaffold(body: Center(child: Text('Route: ${settings.name}'))),
    );
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRouter.home,
    routes: [
      GoRoute(
        path: AppRouter.home,
        builder: (_, __) => Scaffold(
          appBar: AppBar(title: const Text('Driver Ops')),
          body: const Center(child: Text('Home')),
        ),
      ),
      GoRoute(
        path: AppRouter.auth,
        builder: (_, __) => Scaffold(
          appBar: AppBar(title: const Text('Auth')),
          body: const Center(child: Text('Auth')),
        ),
      ),
      GoRoute(
        path: AppRouter.registration,
        builder: (_, __) => Scaffold(
          appBar: AppBar(title: const Text('Registration')),
          body: const Center(child: Text('Registration')),
        ),
      ),
      GoRoute(
        path: AppRouter.profile,
        builder: (_, __) => Scaffold(
          appBar: AppBar(title: const Text('Profile')),
          body: const Center(child: Text('Profile')),
        ),
      ),
      GoRoute(
        path: AppRouter.workday,
        builder: (_, __) => Scaffold(
          appBar: AppBar(title: const Text('Workday')),
          body: const Center(child: Text('Workday')),
        ),
      ),
      GoRoute(
        path: AppRouter.routes,
        builder: (_, __) => Scaffold(
          appBar: AppBar(title: const Text('Routes')),
          body: const Center(child: Text('Routes')),
        ),
      ),
      GoRoute(
        path: AppRouter.pickup,
        builder: (_, __) => Scaffold(
          appBar: AppBar(title: const Text('Pickup')),
          body: const Center(child: Text('Pickup')),
        ),
      ),
      GoRoute(
        path: AppRouter.delivery,
        builder: (_, __) => Scaffold(
          appBar: AppBar(title: const Text('Delivery')),
          body: const Center(child: Text('Delivery')),
        ),
      ),
      GoRoute(
        path: AppRouter.offlineQueue,
        builder: (_, __) => Scaffold(
          appBar: AppBar(title: const Text('Offline queue')),
          body: const Center(child: Text('Offline queue')),
        ),
      ),
    ],
  );
});
