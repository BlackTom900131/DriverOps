// mock auth state
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/models/driver.dart';

class AuthState {
  final bool isLoggedIn;
  final String driverId;
  final DriverStatus driverStatus;
  final String driverName;
  final String? rejectionReason;

  const AuthState({
    required this.isLoggedIn,
    required this.driverId,
    required this.driverStatus,
    required this.driverName,
    this.rejectionReason,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    String? driverId,
    DriverStatus? driverStatus,
    String? driverName,
    String? rejectionReason,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      driverId: driverId ?? this.driverId,
      driverStatus: driverStatus ?? this.driverStatus,
      driverName: driverName ?? this.driverName,
      rejectionReason: rejectionReason ?? this.rejectionReason,
    );
  }
}

class AuthStateNotifier extends StateNotifier<AuthState> {
  final _controller = StreamController<AuthState>.broadcast();
  @override
  Stream<AuthState> get stream => _controller.stream;

  AuthStateNotifier()
    : super(
        const AuthState(
          isLoggedIn: false,
          driverId: 'DRV-001',
          driverStatus: DriverStatus.pending,
          driverName: 'Conductor',
          rejectionReason: null,
        ),
      );

  void _emit(AuthState s) {
    state = s;
    _controller.add(s);
  }

  void mockLogin(String name) {
    // Default to "Pending" to enforce the status gate until you "approve" in UI.
    _emit(state.copyWith(isLoggedIn: true, driverName: name));
  }

  void logout() {
    _emit(
      const AuthState(
        isLoggedIn: false,
        driverId: 'DRV-001',
        driverStatus: DriverStatus.pending,
        driverName: 'Conductor',
      ),
    );
  }

  void setStatus(DriverStatus status, {String? rejectionReason}) {
    _emit(
      state.copyWith(driverStatus: status, rejectionReason: rejectionReason),
    );
  }

  void updateDriverName(String name) {
    _emit(state.copyWith(driverName: name));
  }

  @override
  void dispose() {
    _controller.close();
    super.dispose();
  }
}

final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((
  ref,
) {
  return AuthStateNotifier();
});

// enum DriverStatus { pending, underVerification, approved, rejected, suspended }
