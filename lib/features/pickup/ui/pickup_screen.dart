import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../auth/state/auth_state.dart';
import '../../../shared/extensions/iterable_extensions.dart';
import '../../../shared/models/route_models.dart';
import '../../../shared/widgets/app_scaffold.dart';
import '../../offline_queue/state/offline_queue_state.dart';
import '../../routes/state/routes_state.dart';
import '../data/pickup_sync_service.dart';

class PickupScreen extends ConsumerStatefulWidget {
  final String routeId;
  final String stopId;

  const PickupScreen({super.key, required this.routeId, required this.stopId});

  @override
  ConsumerState<PickupScreen> createState() => _PickupScreenState();
}

class _PickupScreenState extends ConsumerState<PickupScreen> {
  final MobileScannerController _scannerController = MobileScannerController(
    detectionSpeed: DetectionSpeed.noDuplicates,
  );

  bool _isSubmitting = false;
  String? _detectedCode;
  String? _scannedCode;
  MobileScannerException? _cameraError;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(routesProvider.notifier).markStopArrived(widget.routeId, widget.stopId);
    });
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  Future<void> _retryCamera() async {
    setState(() => _cameraError = null);
    await _scannerController.start();
  }

  void _onDetect(BarcodeCapture capture) {
    if (_isSubmitting || _scannedCode != null) return;
    final code = capture.barcodes
        .map((barcode) => barcode.rawValue?.trim())
        .whereType<String>()
        .firstOrNull;
    if (code == null || code.isEmpty || code == _detectedCode) return;
    setState(() => _detectedCode = code);
  }

  Future<void> _submitPickupScan(String code) async {
    if (_isSubmitting || code.trim().isEmpty) return;

    final routesNotifier = ref.read(routesProvider.notifier);
    final stop = routesNotifier.stopById(widget.routeId, widget.stopId);
    if (stop == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('pickup.stop_not_found'))),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    final now = DateTime.now();
    final auth = ref.read(authStateProvider);
    final queue = ref.read(offlineQueueProvider);
    final payload = PickupScanPayload(
      driverId: auth.driverId,
      routeId: widget.routeId,
      stopId: widget.stopId,
      scannedCode: code,
      scannedAt: now,
      latitude: stop.latitude,
      longitude: stop.longitude,
    );

    routesNotifier.markPickupCompleted(widget.routeId, widget.stopId);
    var queued = false;

    if (queue.isOffline) {
      ref.read(offlineQueueProvider.notifier).addMockEvent();
      queued = true;
    } else {
      try {
        await ref.read(pickupSyncServiceProvider).uploadPickupScan(payload);
      } catch (_) {
        ref.read(offlineQueueProvider.notifier).addMockEvent();
        queued = true;
      }
    }

    await _scannerController.stop();
    if (!mounted) return;
    setState(() {
      _scannedCode = code;
      _isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          queued ? tr('pickup.scan_saved_queued') : tr('pickup.scan_uploaded_picked_up'),
        ),
      ),
    );
  }

  void _captureFromCamera() {
    final code = _detectedCode;
    if (code == null || code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(tr('pickup.no_barcode_detected'))),
      );
      return;
    }
    _submitPickupScan(code);
  }

  String _stopStatusLabel(StopStatus? status) {
    if (status == null) return tr('pickup.status_unknown');
    switch (status) {
      case StopStatus.pending:
        return tr('pickup.stop_status_pending');
      case StopStatus.inProgress:
        return tr('pickup.stop_status_in_progress');
      case StopStatus.done:
        return tr('pickup.stop_status_done');
    }
  }

  @override
  Widget build(BuildContext context) {
    final routes = ref.watch(routesProvider);
    final route = routes.routes.where((r) => r.id == widget.routeId).firstOrNull;
    final stop = route?.stops.where((s) => s.id == widget.stopId).firstOrNull;
    final queue = ref.watch(offlineQueueProvider);
    final done = (stop?.status == StopStatus.done) || _scannedCode != null;
    final packageStatus = done
        ? tr('pickup.package_status_picked_up')
        : tr('pickup.package_status_pending');
    final stopStatus = _stopStatusLabel(stop?.status);

    return AppScaffold(
      title: tr('pickup.title', namedArgs: {'stopId': widget.stopId}),
      showOfflineBanner: false,
      body: Stack(
        children: [
          Positioned.fill(
            child: MobileScanner(
              controller: _scannerController,
              onDetect: _onDetect,
              placeholderBuilder: (context, child) => Container(
                color: Colors.black,
                alignment: Alignment.center,
                child: Text(
                  tr('pickup.opening_camera'),
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              errorBuilder: (context, error, child) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (!mounted) return;
                  setState(() => _cameraError = error);
                });
                return Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.videocam_off,
                        color: Colors.white,
                        size: 34,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        error.errorCode == MobileScannerErrorCode.permissionDenied
                            ? tr('pickup.camera_permission_denied')
                            : error.errorCode == MobileScannerErrorCode.unsupported
                                ? tr('pickup.camera_unsupported')
                                : tr('pickup.camera_start_failed'),
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.55),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.7),
                  ],
                  stops: const [0, 0.45, 1],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            right: 16,
            top: 14,
            child: SafeArea(
              bottom: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(
                      'pickup.route_stop',
                      namedArgs: {
                        'routeId': widget.routeId,
                        'stopId': widget.stopId,
                      },
                    ),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    tr(
                      'pickup.package_stop_status',
                      namedArgs: {
                        'packageStatus': packageStatus,
                        'stopStatus': stopStatus,
                      },
                    ),
                    style: TextStyle(
                      color: done ? Colors.lightGreenAccent : Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    queue.isOffline ? tr('pickup.offline_hint') : tr('pickup.online_hint'),
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
          Center(
            child: Container(
              width: 240,
              height: 240,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: BorderRadius.circular(24),
              ),
            ),
          ),
          Positioned(
            left: 24,
            right: 24,
            bottom: 24,
            child: SafeArea(
              top: false,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.58),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _cameraError != null
                          ? tr('pickup.camera_unavailable_retry')
                          : _detectedCode == null
                              ? tr('pickup.align_barcode')
                              : tr(
                                  'pickup.detected_code',
                                  namedArgs: {'code': _detectedCode!},
                                ),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 14),
                  if (_cameraError != null) ...[
                    SizedBox(
                      width: 160,
                      child: OutlinedButton(
                        onPressed: _retryCamera,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.white,
                          side: const BorderSide(color: Colors.white),
                        ),
                        child: Text(tr('pickup.retry_camera')),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  SizedBox(
                    width: 84,
                    height: 84,
                    child: ElevatedButton(
                      onPressed: done || _isSubmitting || _cameraError != null
                          ? null
                          : _captureFromCamera,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: done ? Colors.green : Colors.white,
                        foregroundColor: Colors.black,
                        padding: EdgeInsets.zero,
                      ),
                      child: _isSubmitting
                          ? const SizedBox(
                              width: 28,
                              height: 28,
                              child: CircularProgressIndicator(strokeWidth: 2.4),
                            )
                          : Icon(done ? Icons.check : Icons.camera_alt_outlined, size: 34),
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
