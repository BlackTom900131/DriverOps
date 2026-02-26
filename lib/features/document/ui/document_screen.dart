import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../shared/widgets/app_scaffold.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  static const String _docsPrefKey = 'documents_upload_state_v1';

  static const List<_DocumentDefinition> _personalDocs = [
    _DocumentDefinition(
      id: 'government_id',
      title: 'Government ID',
      section: 'personal',
    ),
    _DocumentDefinition(
      id: 'drivers_license',
      title: 'Valid driver\'s license',
      section: 'personal',
    ),
    _DocumentDefinition(
      id: 'additional_cert',
      title: 'Additional certifications required by the company',
      section: 'personal',
    ),
  ];

  static const List<_DocumentDefinition> _vehicleDocs = [
    _DocumentDefinition(
      id: 'vehicle_registration',
      title: 'Vehicle registration certificate',
      section: 'vehicle',
    ),
    _DocumentDefinition(
      id: 'mandatory_insurance',
      title: 'Mandatory insurance (valid)',
      section: 'vehicle',
    ),
    _DocumentDefinition(
      id: 'technical_inspection',
      title: 'Technical inspection certificate (valid)',
      section: 'vehicle',
    ),
    _DocumentDefinition(
      id: 'additional_insurance',
      title: 'Additional insurance if required',
      section: 'vehicle',
    ),
  ];

  final ImagePicker _picker = ImagePicker();
  final Map<String, _DocumentUploadStatus> _statusById = {};

  @override
  void initState() {
    super.initState();
    for (final doc in [..._personalDocs, ..._vehicleDocs]) {
      _statusById[doc.id] = const _DocumentUploadStatus();
    }
    _loadSavedUploadStatus();
  }

  Future<void> _loadSavedUploadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_docsPrefKey);
    if (raw == null || raw.trim().isEmpty) return;

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return;
      if (!mounted) return;
      setState(() {
        decoded.forEach((id, value) {
          final current = _statusById[id];
          if (current == null || value is! Map<String, dynamic>) return;
          _statusById[id] = _DocumentUploadStatus(
            localPath: value['localPath'] as String?,
            uploadedToServer: value['uploadedToServer'] == true,
          );
        });
      });
    } catch (_) {
      // Ignore malformed persisted payload.
    }
  }

  Future<void> _persistUploadStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final payload = <String, Map<String, dynamic>>{};
    _statusById.forEach((id, status) {
      payload[id] = {
        'localPath': status.localPath,
        'uploadedToServer': status.uploadedToServer,
      };
    });
    await prefs.setString(_docsPrefKey, jsonEncode(payload));
  }

  Future<void> _pickAndUpload(_DocumentDefinition doc, ImageSource source) async {
    final current = _statusById[doc.id];
    if (current == null || current.isUploading) return;

    final picked = await _picker.pickImage(
      source: source,
      imageQuality: 85,
      maxWidth: 2000,
    );
    if (!mounted || picked == null) return;

    setState(() {
      _statusById[doc.id] = current.copyWith(isUploading: true);
    });

    try {
      final localPath = await _saveToInnerStorage(doc, picked.path);
      await _uploadToServerMock();
      if (!mounted) return;
      setState(() {
        _statusById[doc.id] = _DocumentUploadStatus(
          localPath: localPath,
          uploadedToServer: true,
        );
      });
      await _persistUploadStatus();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${doc.title} uploaded')),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _statusById[doc.id] = current.copyWith(isUploading: false);
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to upload ${doc.title}')),
      );
    }
  }

  Future<String> _saveToInnerStorage(_DocumentDefinition doc, String sourcePath) async {
    final appDir = await getApplicationDocumentsDirectory();
    final docsDir = Directory('${appDir.path}${Platform.pathSeparator}documents');
    if (!await docsDir.exists()) {
      await docsDir.create(recursive: true);
    }

    final sourceFile = File(sourcePath);
    final extension = _fileExtension(sourcePath);
    final fileName = '${doc.id}_${DateTime.now().millisecondsSinceEpoch}$extension';
    final targetPath = '${docsDir.path}${Platform.pathSeparator}$fileName';
    final saved = await sourceFile.copy(targetPath);
    return saved.path;
  }

  String _fileExtension(String path) {
    final normalized = path.replaceAll('\\', '/');
    final index = normalized.lastIndexOf('.');
    if (index == -1 || index == normalized.length - 1) return '.jpg';
    return normalized.substring(index);
  }

  Future<void> _uploadToServerMock() async {
    await Future<void>.delayed(const Duration(seconds: 2));
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Mandatory Document Upload',
      body: ListView(
        padding: const EdgeInsets.only(top: 8, bottom: 20),
        children: [
          _DocumentSection(
            title: 'Personal documents',
            icon: Icons.person_outline,
            docs: _personalDocs,
            statusById: _statusById,
            onPick: _pickAndUpload,
          ),
          _DocumentSection(
            title: 'Vehicle documents',
            icon: Icons.local_shipping_outlined,
            docs: _vehicleDocs,
            statusById: _statusById,
            onPick: _pickAndUpload,
          ),
        ],
      ),
    );
  }
}

class _DocumentSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<_DocumentDefinition> docs;
  final Map<String, _DocumentUploadStatus> statusById;
  final Future<void> Function(_DocumentDefinition doc, ImageSource source) onPick;

  const _DocumentSection({
    required this.title,
    required this.icon,
    required this.docs,
    required this.statusById,
    required this.onPick,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon),
                const SizedBox(width: 8),
                Text(title, style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
            const SizedBox(height: 12),
            ...docs.map((doc) {
              final status = statusById[doc.id] ?? const _DocumentUploadStatus();
              final isSaved = status.localPath != null && status.localPath!.isNotEmpty;
              final uploadText = status.isUploading
                  ? 'Uploading to server...'
                  : status.uploadedToServer
                  ? 'Uploaded to server and inner storage'
                  : isSaved
                  ? 'Saved to inner storage'
                  : 'Not uploaded';

              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Theme.of(context).dividerColor),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(doc.title),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Icon(
                            status.uploadedToServer
                                ? Icons.cloud_done_outlined
                                : isSaved
                                ? Icons.save_alt_outlined
                                : Icons.cloud_upload_outlined,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              uploadText,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                          if (status.isUploading)
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: status.isUploading
                                  ? null
                                  : () => onPick(doc, ImageSource.gallery),
                              icon: const Icon(Icons.photo_library_outlined),
                              label: const Text('Gallery'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: status.isUploading
                                  ? null
                                  : () => onPick(doc, ImageSource.camera),
                              icon: const Icon(Icons.photo_camera_outlined),
                              label: const Text('Camera'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _DocumentDefinition {
  final String id;
  final String title;
  final String section;

  const _DocumentDefinition({
    required this.id,
    required this.title,
    required this.section,
  });
}

class _DocumentUploadStatus {
  final String? localPath;
  final bool uploadedToServer;
  final bool isUploading;

  const _DocumentUploadStatus({
    this.localPath,
    this.uploadedToServer = false,
    this.isUploading = false,
  });

  _DocumentUploadStatus copyWith({
    String? localPath,
    bool? uploadedToServer,
    bool? isUploading,
  }) {
    return _DocumentUploadStatus(
      localPath: localPath ?? this.localPath,
      uploadedToServer: uploadedToServer ?? this.uploadedToServer,
      isUploading: isUploading ?? this.isUploading,
    );
  }
}
