import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/widgets/app_scaffold.dart';

class VehicleScreen extends StatefulWidget {
  const VehicleScreen({super.key});

  @override
  State<VehicleScreen> createState() => _VehicleScreenState();
}

class _VehicleScreenState extends State<VehicleScreen> {
  static const String _dropdownOptionsAsset =
      'Assets/vehicle_dropdown_options.json';
  static const List<String> _defaultVehicleTypes = [
    'Coche',
    'Camión',
    'Bicicleta',
    'Motocicleta',
    'Furgoneta',
    'Autobús',
    'Otro',
  ];
  static const List<String> _defaultVehicleBrands = [
    'Toyota',
    'Honda',
    'Ford',
    'Chevrolet',
    'Nissan',
    'Hyundai',
    'Kia',
    'Volkswagen',
    'BMW',
    'Mercedes-Benz',
    'Audi',
    'Lexus',
    'Mazda',
    'Subaru',
    'Jeep',
    'Dodge',
    'Ram',
    'GMC',
    'Tesla',
    'Volvo',
    'Peugeot',
    'Renault',
    'Skoda',
    'Fiat',
    'Suzuki',
    'Mitsubishi',
    'Isuzu',
    'Tata',
    'Mahindra',
    'BYD',
    'Otro',
  ];
  static const List<String> _defaultVehicleModels = [
    'Corolla',
    'Camry',
    'Hilux',
    'Civic',
    'Accord',
    'CR-V',
    'F-150',
    'Ranger',
    'Silverado',
    'Model 3',
    'Model Y',
    'X5',
    'C-Class',
    'A4',
    'Elantra',
    'Sportage',
    'Polo',
    'Swift',
    'Otro',
  ];
  static const String _prefType = 'vehicle_type';
  static const String _prefBrand = 'vehicle_brand';
  static const String _prefModel = 'vehicle_model';
  static const String _prefYear = 'vehicle_year';
  static const String _prefPlate = 'vehicle_plate';
  static const String _prefRegistration = 'vehicle_registration';
  static const String _prefPhotoPath = 'vehicle_photo_path';

  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  late List<String> _vehicleTypes;
  late List<String> _vehicleBrands;
  late List<String> _vehicleModels;
  late final TextEditingController _customTypeCtrl;
  late final TextEditingController _customBrandCtrl;
  late final TextEditingController _customModelCtrl;
  late final TextEditingController _yearCtrl;
  late final TextEditingController _plateCtrl;
  late final TextEditingController _registrationCtrl;
  String? _vehiclePhotoPath;
  late String _selectedVehicleType;
  late String _selectedBrand;
  late String _selectedModel;
  bool _isSaving = false;
  OverlayEntry? _toastEntry;

  String _savedType = 'Camión';
  String _savedBrand = 'Toyota';
  String _savedModel = 'Hilux';
  String _savedYear = '2022';
  String _savedPlate = 'ABC-1234';
  String _savedRegistration = 'REG-998877';

  @override
  void initState() {
    super.initState();
    _vehicleTypes = List<String>.from(_defaultVehicleTypes);
    _vehicleBrands = List<String>.from(_defaultVehicleBrands);
    _vehicleModels = List<String>.from(_defaultVehicleModels);
    _customTypeCtrl = TextEditingController();
    _customBrandCtrl = TextEditingController();
    _customModelCtrl = TextEditingController();
    _syncSelectionsWithSavedValues();
    _yearCtrl = TextEditingController(text: _savedYear);
    _plateCtrl = TextEditingController(text: _savedPlate);
    _registrationCtrl = TextEditingController(text: _savedRegistration);
    _loadSavedVehicleData();
    _loadVehicleDropdownOptions();
  }

  @override
  void dispose() {
    _toastEntry?.remove();
    _customTypeCtrl.dispose();
    _customBrandCtrl.dispose();
    _customModelCtrl.dispose();
    _yearCtrl.dispose();
    _plateCtrl.dispose();
    _registrationCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickVehiclePhoto(ImageSource source) async {
    if (_isSaving) return;
    final file = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 1800,
    );
    if (!mounted || file == null) return;
    setState(() => _vehiclePhotoPath = file.path);
  }

  Future<void> _pickYear() async {
    final currentYear = DateTime.now().year;
    final parsedYear = int.tryParse(_yearCtrl.text.trim()) ?? currentYear;
    final initialYear = parsedYear.clamp(1950, currentYear + 1);
    final pickedYear = await showDialog<int>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Seleccionar año del vehículo'),
          content: SizedBox(
            width: 320,
            height: 300,
            child: YearPicker(
              firstDate: DateTime(1950, 1, 1),
              lastDate: DateTime(currentYear + 1, 12, 31),
              selectedDate: DateTime(initialYear, 1, 1),
              onChanged: (pickedDate) {
                Navigator.of(dialogContext).pop(pickedDate.year);
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancelar'),
            ),
          ],
        );
      },
    );
    if (!mounted || pickedYear == null) return;
    setState(() => _yearCtrl.text = pickedYear.toString());
  }

  Future<void> _loadVehicleDropdownOptions() async {
    try {
      final raw = await rootBundle.loadString(_dropdownOptionsAsset);
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return;

      final loadedTypes = _readOptions(
        decoded['types'],
        fallback: _defaultVehicleTypes,
      );
      final loadedBrands = _readOptions(
        decoded['brands'],
        fallback: _defaultVehicleBrands,
      );
      final loadedModels = _readOptions(
        decoded['models'],
        fallback: _defaultVehicleModels,
      );

      if (!mounted) return;
      setState(() {
        _vehicleTypes = loadedTypes;
        _vehicleBrands = loadedBrands;
        _vehicleModels = loadedModels;
        _syncSelectionsWithSavedValues();
      });
    } catch (_) {
      // Keep defaults when asset is unavailable or invalid.
    }
  }

  Future<void> _loadSavedVehicleData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedType = prefs.getString(_prefType);
    final savedBrand = prefs.getString(_prefBrand);
    final savedModel = prefs.getString(_prefModel);
    final savedYear = prefs.getString(_prefYear);
    final savedPlate = prefs.getString(_prefPlate);
    final savedRegistration = prefs.getString(_prefRegistration);
    final savedPhotoPath = prefs.getString(_prefPhotoPath);

    if (!mounted) return;
    setState(() {
      _savedType = savedType?.trim().isNotEmpty == true
          ? savedType!.trim()
          : _savedType;
      _savedBrand = savedBrand?.trim().isNotEmpty == true
          ? savedBrand!.trim()
          : _savedBrand;
      _savedModel = savedModel?.trim().isNotEmpty == true
          ? savedModel!.trim()
          : _savedModel;
      _savedYear = savedYear?.trim().isNotEmpty == true
          ? savedYear!.trim()
          : _savedYear;
      _savedPlate = savedPlate?.trim().isNotEmpty == true
          ? savedPlate!.trim()
          : _savedPlate;
      _savedRegistration = savedRegistration?.trim().isNotEmpty == true
          ? savedRegistration!.trim()
          : _savedRegistration;
      _vehiclePhotoPath = savedPhotoPath?.trim().isNotEmpty == true
          ? savedPhotoPath!.trim()
          : _vehiclePhotoPath;
      _syncSelectionsWithSavedValues();
      _yearCtrl.text = _savedYear;
      _plateCtrl.text = _savedPlate;
      _registrationCtrl.text = _savedRegistration;
    });
  }

  Future<void> _saveVehicleDataLocally() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_prefType, _savedType);
    await prefs.setString(_prefBrand, _savedBrand);
    await prefs.setString(_prefModel, _savedModel);
    await prefs.setString(_prefYear, _savedYear);
    await prefs.setString(_prefPlate, _savedPlate);
    await prefs.setString(_prefRegistration, _savedRegistration);
    await prefs.setString(_prefPhotoPath, _vehiclePhotoPath ?? '');
  }

  Future<void> _confirmAndSave() async {
    if (_isSaving) return;
    if (!_formKey.currentState!.validate()) return;

    final shouldSave = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Confirmar guardado'),
          content: const Text(
            '¿Desea guardar la información del vehículo localmente?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              child: const Text('Confirmar'),
            ),
          ],
        );
      },
    );

    if (!mounted || shouldSave != true) return;

    setState(() => _isSaving = true);
    try {
      _savedType = _selectedVehicleType == 'Otro'
          ? _customTypeCtrl.text.trim()
          : _selectedVehicleType;
      _savedBrand = _selectedBrand == 'Otro'
          ? _customBrandCtrl.text.trim()
          : _selectedBrand;
      _savedModel = _selectedModel == 'Otro'
          ? _customModelCtrl.text.trim()
          : _selectedModel;
      _savedYear = _yearCtrl.text.trim();
      _savedPlate = _plateCtrl.text.trim();
      _savedRegistration = _registrationCtrl.text.trim();

      await Future<void>.delayed(const Duration(milliseconds: 400));
      await _saveVehicleDataLocally();

      if (!mounted) return;
      _showToast('Información del vehículo guardada localmente');
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  void _showToast(String message) {
    _toastEntry?.remove();
    _toastEntry = OverlayEntry(
      builder: (context) => Positioned(
        left: 20,
        right: 20,
        bottom: 110,
        child: Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.black87,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                message,
                style: const TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );

    final overlay = Overlay.of(context);
    overlay.insert(_toastEntry!);
    Future<void>.delayed(const Duration(seconds: 2), () {
      _toastEntry?.remove();
      _toastEntry = null;
    });
  }

  List<String> _readOptions(Object? source, {required List<String> fallback}) {
    final input = source is List ? source : const <Object>[];
    final values = <String>{};
    for (final item in input) {
      if (item is! String) continue;
      final value = item.trim();
      if (value.isNotEmpty) values.add(value);
    }
    if (values.isEmpty) return List<String>.from(fallback);
    values.add('Otro');
    return values.toList();
  }

  void _syncSelectionsWithSavedValues() {
    _selectedVehicleType = _vehicleTypes.contains(_savedType)
        ? _savedType
        : 'Otro';
    _customTypeCtrl.text = _selectedVehicleType == 'Otro' ? _savedType : '';

    _selectedBrand = _vehicleBrands.contains(_savedBrand)
        ? _savedBrand
        : 'Otro';
    _customBrandCtrl.text = _selectedBrand == 'Otro' ? _savedBrand : '';

    _selectedModel = _vehicleModels.contains(_savedModel)
        ? _savedModel
        : 'Otro';
    _customModelCtrl.text = _selectedModel == 'Otro' ? _savedModel : '';
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Información del vehículo',
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 20),
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: _vehiclePhotoPath == null
                    ? Image.asset(
                        'Assets/truck.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return ColoredBox(
                            color: Theme.of(
                              context,
                            ).colorScheme.surfaceContainerHighest,
                            child: const Center(
                              child: Icon(
                                Icons.local_shipping_outlined,
                                size: 48,
                              ),
                            ),
                          );
                        },
                      )
                    : Image.file(File(_vehiclePhotoPath!), fit: BoxFit.cover),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isSaving
                        ? null
                        : () => _pickVehiclePhoto(ImageSource.gallery),
                    icon: const Icon(Icons.photo_library_outlined),
                    label: const Text('Desde la galería'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _isSaving
                        ? null
                        : () => _pickVehiclePhoto(ImageSource.camera),
                    icon: const Icon(Icons.photo_camera_outlined),
                    label: const Text('Desde la cámara'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      initialValue: _selectedVehicleType,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de vehículo',
                        prefixIcon: Icon(Icons.local_shipping_outlined),
                      ),
                      items: _vehicleTypes
                          .map(
                            (type) => DropdownMenuItem<String>(
                              value: type,
                              child: Text(type),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _selectedVehicleType = value);
                      },
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Requerido' : null,
                    ),
                    if (_selectedVehicleType == 'Otro') ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _customTypeCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Especifique el tipo de vehículo',
                          prefixIcon: Icon(Icons.edit_outlined),
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Requerido'
                                : null,
                      ),
                    ],
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedBrand,
                      decoration: const InputDecoration(
                        labelText: 'Marca',
                        prefixIcon: Icon(
                          Icons.precision_manufacturing_outlined,
                        ),
                      ),
                      items: _vehicleBrands
                          .map(
                            (brand) => DropdownMenuItem<String>(
                              value: brand,
                              child: Text(brand),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _selectedBrand = value);
                      },
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Requerido' : null,
                    ),
                    if (_selectedBrand == 'Otro') ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _customBrandCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Especifique la marca',
                          prefixIcon: Icon(Icons.edit_outlined),
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Requerido'
                                : null,
                      ),
                    ],
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedModel,
                      decoration: const InputDecoration(
                        labelText: 'Modelo',
                        prefixIcon: Icon(Icons.directions_car_outlined),
                      ),
                      items: _vehicleModels
                          .map(
                            (model) => DropdownMenuItem<String>(
                              value: model,
                              child: Text(model),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _selectedModel = value);
                      },
                      validator: (v) =>
                          (v == null || v.isEmpty) ? 'Requerido' : null,
                    ),
                    if (_selectedModel == 'Otro') ...[
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _customModelCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Especifique el modelo',
                          prefixIcon: Icon(Icons.edit_outlined),
                        ),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Requerido'
                                : null,
                      ),
                    ],
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _yearCtrl,
                      readOnly: true,
                      onTap: _pickYear,
                      decoration: const InputDecoration(
                        labelText: 'Año',
                        prefixIcon: Icon(Icons.calendar_today_outlined),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Requerido'
                              : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _plateCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Número de placa',
                        prefixIcon: Icon(Icons.confirmation_number_outlined),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Requerido'
                              : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _registrationCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Número de registro del vehículo',
                        prefixIcon: Icon(Icons.assignment_outlined),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty)
                              ? 'Requerido'
                              : null,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isSaving
                        ? null
                        : () {
                            _syncSelectionsWithSavedValues();
                            _yearCtrl.text = _savedYear;
                            _plateCtrl.text = _savedPlate;
                            _registrationCtrl.text = _savedRegistration;
                            setState(() {});
                          },
                    child: const Text('Cancelar'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: _isSaving ? null : _confirmAndSave,
                    child: _isSaving
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2.2),
                          )
                        : const Text('Guardar vehículo'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
