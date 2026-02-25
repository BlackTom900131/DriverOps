import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

import '../../auth/state/auth_state.dart';
import '../../../shared/widgets/app_scaffold.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  XFile? _selfieFile;
  bool _capturing = false;
  final ImagePicker _picker = ImagePicker();
  late final TextEditingController _fullNameCtrl;
  late final TextEditingController _governmentIdCtrl;
  late final TextEditingController _dobCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _addressCtrl;

  String _savedFullName = '';
  String _savedGovernmentId = 'GOV-1234-5678';
  String _savedDob = '1995-03-20';
  String _savedPhone = '+1 555 010 2244';
  String _savedEmail = 'driver@company.com';
  String _savedAddress = '221B Baker Street, Springfield, USA';

  @override
  void initState() {
    super.initState();
    _savedFullName = ref.read(authStateProvider).driverName;
    _fullNameCtrl = TextEditingController(text: _savedFullName);
    _governmentIdCtrl = TextEditingController(text: _savedGovernmentId);
    _dobCtrl = TextEditingController(text: _savedDob);
    _phoneCtrl = TextEditingController(text: _savedPhone);
    _emailCtrl = TextEditingController(text: _savedEmail);
    _addressCtrl = TextEditingController(text: _savedAddress);
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _governmentIdCtrl.dispose();
    _dobCtrl.dispose();
    _phoneCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    super.dispose();
  }

  Future<void> _captureSelfie() async {
    setState(() => _capturing = true);
    try {
      final photo = await _picker.pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.front,
        imageQuality: 80,
      );
      if (!mounted) return;
      if (photo != null) {
        setState(() => _selfieFile = photo);
      }
    } finally {
      if (mounted) {
        setState(() => _capturing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Profile',
      body: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          const SizedBox(height: 8),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 12),
                  CircleAvatar(
                    radius: 72,
                    backgroundColor: const Color(0xFFF4F6FA),
                    backgroundImage: _selfieFile == null
                        ? null
                        : FileImage(File(_selfieFile!.path)),
                    child: _selfieFile == null
                        ? const Icon(
                            Icons.person,
                            size: 64,
                            color: Color(0xFF8A94A6),
                          )
                        : null,
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: _capturing ? null : _captureSelfie,
                      icon: const Icon(Icons.camera_alt_outlined),
                      label: Text(
                        _capturing ? 'Capturing...' : 'Capture Selfie',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _fullNameCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Full name',
                        prefixIcon: Icon(Icons.badge_outlined),
                      ),
                      validator: (v) =>
                          (v == null || v.trim().isEmpty) ? 'Required' : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _governmentIdCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Government ID number',
                        prefixIcon: Icon(Icons.credit_card_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _dobCtrl,
                      decoration: const InputDecoration(
                        labelText: 'Date of birth',
                        hintText: 'YYYY-MM-DD',
                        prefixIcon: Icon(Icons.cake_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _phoneCtrl,
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(
                        labelText: 'Phone number',
                        prefixIcon: Icon(Icons.phone_outlined),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _emailCtrl,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: 'Email address',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                      validator: (v) => (v == null || !v.contains('@'))
                          ? 'Invalid email'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _addressCtrl,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Residential address',
                        prefixIcon: Icon(Icons.home_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Card(
            child: Column(
              children: const [
                ListTile(
                  leading: Icon(Icons.fingerprint),
                  title: Text('Biometric login'),
                  subtitle: Text('Enabled (mock)'),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.lock_clock_outlined),
                  title: Text('Session policy'),
                  subtitle: Text('Auto logout after inactivity (mock)'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      _fullNameCtrl.text = _savedFullName;
                      _governmentIdCtrl.text = _savedGovernmentId;
                      _dobCtrl.text = _savedDob;
                      _phoneCtrl.text = _savedPhone;
                      _emailCtrl.text = _savedEmail;
                      _addressCtrl.text = _savedAddress;
                    },
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      if (!_formKey.currentState!.validate()) return;
                      _savedFullName = _fullNameCtrl.text.trim();
                      _savedGovernmentId = _governmentIdCtrl.text.trim();
                      _savedDob = _dobCtrl.text.trim();
                      _savedPhone = _phoneCtrl.text.trim();
                      _savedEmail = _emailCtrl.text.trim();
                      _savedAddress = _addressCtrl.text.trim();
                      ref
                          .read(authStateProvider.notifier)
                          .updateDriverName(_savedFullName);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Profile saved')),
                      );
                    },
                    child: const Text('Save Profile'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}
