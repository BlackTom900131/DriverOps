import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
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
      ref
          .read(routesProvider.notifier)
          .markStopArrived(widget.routeId, widget.stopId);
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
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(content: Text('No se encontraron datos de la parada.')),
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
          queued
              ? 'Escaneo guardado. Subida en cola para sincronizar.'
              : 'Escaneo subido. Paquete marcado como Recogido.',
        ),
      ),
    );
  }

  void _captureFromCamera() {
    final code = _detectedCode;
    if (code == null || code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'No se detectó código de barras/QR. Alinee el código e intente de nuevo.',
          ),
        ),
      );
      return;
    }
    _submitPickupScan(code);
  }

  String _stopStatusLabel(StopStatus? status) {
    if (status == null) return 'desconocido';
    switch (status) {
      case StopStatus.pending:
        return 'Pendiente';
      case StopStatus.inProgress:
        return 'En progreso';
      case StopStatus.done:
        return 'Recogido';
    }
  }

  @override
  Widget build(BuildContext context) {
    final routes = ref.watch(routesProvider);
    final route = routes.routes
        .where((r) => r.id == widget.routeId)
        .firstOrNull;
    final stop = route?.stops.where((s) => s.id == widget.stopId).firstOrNull;
    final queue = ref.watch(offlineQueueProvider);
    final done = (stop?.status == StopStatus.done) || _scannedCode != null;
    final packageStatus = done ? 'Recogido' : 'Pendiente';
    final stopStatus = _stopStatusLabel(stop?.status);

    return AppScaffold(
      title: 'Escaneo de recogida - ${widget.stopId}',
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
                child: const Text(
                  'Abriendo cámara...',
                  style: TextStyle(color: Colors.white),
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
                        error.errorCode ==
                                MobileScannerErrorCode.permissionDenied
                            ? 'Permiso de cámara denegado. Permita el acceso a la cámara.'
                            : error.errorCode ==
                                  MobileScannerErrorCode.unsupported
                            ? 'El escáner de cámara no es compatible con este dispositivo/plataforma.'
                            : 'No se puede iniciar el escáner de cámara.',
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
                    'Ruta ${widget.routeId}  |  Parada ${widget.stopId}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Paquete: $packageStatus  |  Parada: $stopStatus',
                    style: TextStyle(
                      color: done ? Colors.lightGreenAccent : Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    queue.isOffline
                        ? 'Sin conexión: el evento de recogida se pondrá en cola y se sincronizará automáticamente.'
                        : 'En línea: el evento de recogida se sube automáticamente después de la captura.',
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
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.58),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _cameraError != null
                          ? 'Cámara no disponible. Corrija permisos/soporte del dispositivo y toque Reintentar.'
                          : _detectedCode == null
                          ? 'Alinee el código de barras/QR dentro del marco'
                          : 'Detectado: $_detectedCode',
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
                        child: const Text('Reintentar cámara'),
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
                              child: CircularProgressIndicator(
                                strokeWidth: 2.4,
                              ),
                            )
                          : Icon(
                              done ? Icons.check : Icons.camera_alt_outlined,
                              size: 34,
                            ),
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
