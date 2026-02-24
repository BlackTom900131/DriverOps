# DriverOps

DriverOps is a Flutter application for driver operations workflow: authentication, driver status tracking, registration flow, workday flow, route handling, and offline queue simulation.

## Current App Flow

1. Login landing page with `Login` and `Register` actions.
2. Login details page (name, email, password).
3. After login success, navigate to the Driver Status page.
4. Driver Status page shows one active status with a large icon:
   - Pending review
   - Under verification
   - Approved
   - Rejected
   - Suspended

## UI Highlights

- Shared bottom navigation across app pages (`Home`, `Status`, `Offline`, `Profile`).
- Offline banner appears only when the app is in offline mode.
- Login screen uses a local background image asset from `Assets/`.

## Project Setup

```bash
flutter pub get
flutter run
```

## Testing Offline State

Toggle offline mode from the `Offline Queue` screen (`Go Offline` / `Go Online`), or set initial state in:

- `lib/features/offline_queue/state/offline_queue_state.dart`

```dart
OfflineQueueNotifier()
  : super(const OfflineQueueState(isOffline: true, pendingEvents: 0));
```

Then perform a hot restart.
