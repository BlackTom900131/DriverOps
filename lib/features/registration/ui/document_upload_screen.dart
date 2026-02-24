import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

/// Screen for uploading driver documents: ID, license, vehicle registration,
/// and selfie photo.
class DocumentUploadScreen extends StatefulWidget {
  const DocumentUploadScreen({super.key});

  @override
  State<DocumentUploadScreen> createState() => _DocumentUploadScreenState();
}

class _DocumentUploadScreenState extends State<DocumentUploadScreen> {
  final ImagePicker _picker = ImagePicker();

  File? _idDocument;
  File? _licenseDocument;
  File? _vehicleRegistrationDocument;
  File? _selfiePhoto;

  String? _idBase64;
  String? _licenseBase64;
  String? _vehicleRegBase64;
  String? _selfieBase64;

  Future<void> _pickImage(ImageSource source, _DocumentSlot slot) async {
    try {
      final image = await _picker.pickImage(
        source: source,
        imageQuality: 80,
      );
      if (image == null || !mounted) return;
      final file = File(image.path);
      final bytes = await file.readAsBytes();
      final base64 = base64Encode(bytes);
      setState(() {
        switch (slot) {
          case _DocumentSlot.id:
            _idDocument = file;
            _idBase64 = base64;
            break;
          case _DocumentSlot.license:
            _licenseDocument = file;
            _licenseBase64 = base64;
            break;
          case _DocumentSlot.vehicleReg:
            _vehicleRegistrationDocument = file;
            _vehicleRegBase64 = base64;
            break;
          case _DocumentSlot.selfie:
            _selfiePhoto = file;
            _selfieBase64 = base64;
            break;
        }
      });
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  void _clearSlot(_DocumentSlot slot) {
    setState(() {
      switch (slot) {
        case _DocumentSlot.id:
          _idDocument = null;
          _idBase64 = null;
          break;
        case _DocumentSlot.license:
          _licenseDocument = null;
          _licenseBase64 = null;
          break;
        case _DocumentSlot.vehicleReg:
          _vehicleRegistrationDocument = null;
          _vehicleRegBase64 = null;
          break;
        case _DocumentSlot.selfie:
          _selfiePhoto = null;
          _selfieBase64 = null;
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Document Upload'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _DocumentTile(
            title: 'Government ID',
            file: _idDocument,
            base64: _idBase64,
            onPick: (source) => _pickImage(source, _DocumentSlot.id),
            onClear: () => _clearSlot(_DocumentSlot.id),
          ),
          const SizedBox(height: 16),
          _DocumentTile(
            title: 'Driver License',
            file: _licenseDocument,
            base64: _licenseBase64,
            onPick: (source) => _pickImage(source, _DocumentSlot.license),
            onClear: () => _clearSlot(_DocumentSlot.license),
          ),
          const SizedBox(height: 16),
          _DocumentTile(
            title: 'Vehicle Registration',
            file: _vehicleRegistrationDocument,
            base64: _vehicleRegBase64,
            onPick: (source) => _pickImage(source, _DocumentSlot.vehicleReg),
            onClear: () => _clearSlot(_DocumentSlot.vehicleReg),
          ),
          const SizedBox(height: 16),
          _DocumentTile(
            title: 'Selfie Photo',
            file: _selfiePhoto,
            base64: _selfieBase64,
            onPick: (source) => _pickImage(source, _DocumentSlot.selfie),
            onClear: () => _clearSlot(_DocumentSlot.selfie),
          ),
        ],
      ),
    );
  }
}

enum _DocumentSlot { id, license, vehicleReg, selfie }

class _DocumentTile extends StatelessWidget {
  const _DocumentTile({
    required this.title,
    required this.file,
    required this.base64,
    required this.onPick,
    required this.onClear,
  });

  final String title;
  final File? file;
  final String? base64;
  final void Function(ImageSource source) onPick;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final hasImage = file != null || base64 != null;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (hasImage) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: file != null
                    ? Image.file(
                        file!,
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.memory(
                        base64Decode(base64!),
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  TextButton.icon(
                    onPressed: onClear,
                    icon: const Icon(Icons.delete_outline, size: 18),
                    label: const Text('Remove'),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: () => _showSourcePicker(context),
                    icon: const Icon(Icons.refresh, size: 18),
                    label: const Text('Replace'),
                  ),
                ],
              ),
            ] else
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () => onPick(ImageSource.camera),
                      icon: const Icon(Icons.camera_alt, size: 20),
                      label: const Text('Camera'),
                    ),
                    const SizedBox(width: 8),
                    OutlinedButton.icon(
                      onPressed: () => onPick(ImageSource.gallery),
                      icon: const Icon(Icons.photo_library, size: 20),
                      label: const Text('Gallery'),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showSourcePicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                onPick(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                onPick(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }
}
