import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

import '../../../shared/widgets/app_scaffold.dart';

class DocumentScreen extends StatefulWidget {
  const DocumentScreen({super.key});

  @override
  State<DocumentScreen> createState() => _DocumentScreenState();
}

class _DocumentScreenState extends State<DocumentScreen> {
  static const String _secureUploadEndpoint =
      'https://example.com/api/documents/upload';
  static const List<String> _allowedImageExtensions = [
    'jpg',
    'jpeg',
    'png',
    'webp',
  ];
  static const List<String> _allowedExtensions = [
    'jpg',
    'jpeg',
    'png',
    'webp',
    'pdf',
  ];

  static const List<_DocumentDefinition> _personalDocs = [
    _DocumentDefinition(
      id: 'government_id',
      title: 'Government ID',
      maxSizeMb: 8,
    ),
    _DocumentDefinition(
      id: 'drivers_license',
      title: 'Valid driver\'s license',
      maxSizeMb: 8,
    ),
    _DocumentDefinition(
      id: 'additional_cert',
      title: 'Additional certifications required by the company',
      maxSizeMb: 8,
    ),
  ];

  static const List<_DocumentDefinition> _vehicleDocs = [
    _DocumentDefinition(
      id: 'vehicle_registration',
      title: 'Vehicle registration certificate',
      maxSizeMb: 10,
    ),
    _DocumentDefinition(
      id: 'mandatory_insurance',
      title: 'Mandatory insurance (valid)',
      maxSizeMb: 10,
    ),
    _DocumentDefinition(
      id: 'technical_inspection',
      title: 'Technical inspection certificate (valid)',
      maxSizeMb: 10,
    ),
    _DocumentDefinition(
      id: 'additional_insurance',
      title: 'Additional insurance if required',
      maxSizeMb: 10,
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
  }

  Future<void> _pickFromCamera(_DocumentDefinition doc) async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 100,
      maxWidth: 3000,
    );
    if (!mounted || picked == null) return;
    await _validateCompressAndUpload(doc, picked.path);
  }

  Future<void> _pickFromGallery(_DocumentDefinition doc) async {
    final picked = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxWidth: 3000,
    );
    if (!mounted || picked == null) return;
    await _validateCompressAndUpload(doc, picked.path);
  }

  Future<void> _pickPdf(_DocumentDefinition doc) async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: const ['pdf'],
      withData: false,
      allowMultiple: false,
    );
    final path = result?.files.single.path;
    if (!mounted || path == null || path.trim().isEmpty) return;
    await _validateCompressAndUpload(doc, path);
  }

  Future<void> _showGallerySourcePicker(_DocumentDefinition doc) async {
    await showModalBottomSheet<void>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Image from Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickFromGallery(doc);
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_outlined),
                title: const Text('PDF Document'),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickPdf(doc);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _validateCompressAndUpload(
    _DocumentDefinition doc,
    String sourcePath,
  ) async {
    final current = _statusById[doc.id] ?? const _DocumentUploadStatus();
    if (current.isUploading) return;

    final extension = _fileExtension(sourcePath);
    if (!_allowedExtensions.contains(extension)) {
      _showInfo('Only image or PDF files are allowed.');
      return;
    }

    final sourceFile = File(sourcePath);
    if (!await sourceFile.exists()) {
      _showInfo('Selected file is not available.');
      return;
    }

    File fileToUpload = sourceFile;
    bool shouldDeleteUploadFileAfter = false;

    try {
      if (_allowedImageExtensions.contains(extension)) {
        final compressed = await _compressImage(sourceFile);
        if (compressed != null) {
          fileToUpload = compressed;
          shouldDeleteUploadFileAfter = true;
        }
      }

      final fileBytes = await fileToUpload.length();
      final maxBytes = doc.maxSizeMb * 1024 * 1024;
      if (fileBytes > maxBytes) {
        _showInfo('File is too large. Max ${doc.maxSizeMb} MB allowed.');
        return;
      }

      setState(() {
        _statusById[doc.id] = current.copyWith(
          isUploading: true,
          uploadedToServer: false,
          statusText: 'Uploading securely to cloud...',
        );
      });

      final serverReason = await _uploadToSecureCloud(
        documentId: doc.id,
        file: fileToUpload,
        extension: extension,
      );

      if (!mounted) return;
      setState(() {
        _statusById[doc.id] = _DocumentUploadStatus(
          isUploading: false,
          uploadedToServer: true,
          statusText: serverReason,
        );
      });
    } catch (error) {
      final serverReason = _extractServerReason(error);
      if (!mounted) return;
      setState(() {
        _statusById[doc.id] = current.copyWith(
          isUploading: false,
          uploadedToServer: false,
          statusText: 'Upload failed: $serverReason',
        );
      });
    } finally {
      if (shouldDeleteUploadFileAfter && await fileToUpload.exists()) {
        await fileToUpload.delete();
      }
    }
  }

  Future<File?> _compressImage(File sourceFile) async {
    final targetPath =
        '${Directory.systemTemp.path}${Platform.pathSeparator}'
        'doc_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final compressed = await FlutterImageCompress.compressAndGetFile(
      sourceFile.path,
      targetPath,
      quality: 80,
      minWidth: 1600,
      minHeight: 1600,
      keepExif: true,
      format: CompressFormat.jpeg,
    );
    if (compressed == null) return null;
    return File(compressed.path);
  }

  Future<String> _uploadToSecureCloud({
    required String documentId,
    required File file,
    required String extension,
  }) async {
    final endpoint = Uri.parse(_secureUploadEndpoint);
    if (endpoint.scheme.toLowerCase() != 'https') {
      throw Exception('Upload endpoint must use HTTPS.');
    }

    // Replace this mock with your real secure API upload implementation.
    // The key constraint enforced here is HTTPS transport.
    await Future<void>.delayed(const Duration(seconds: 2));
    if (!await file.exists()) {
      throw Exception('Upload source missing on device.');
    }
    final _ = documentId + extension;
    return 'Uploaded securely. Server reason: Document accepted.';
  }

  String _extractServerReason(Object error) {
    final text = error.toString().trim();
    if (text.isEmpty) return 'Unknown server error.';
    if (text.startsWith('Exception: ')) {
      return text.substring('Exception: '.length);
    }
    return text;
  }

  String _fileExtension(String path) {
    final normalized = path.replaceAll('\\', '/').toLowerCase();
    final index = normalized.lastIndexOf('.');
    if (index == -1 || index == normalized.length - 1) return '';
    return normalized.substring(index + 1);
  }

  void _showInfo(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
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
            onCamera: _pickFromCamera,
            onGalleryOrPdf: _showGallerySourcePicker,
          ),
          _DocumentSection(
            title: 'Vehicle documents',
            icon: Icons.local_shipping_outlined,
            docs: _vehicleDocs,
            statusById: _statusById,
            onCamera: _pickFromCamera,
            onGalleryOrPdf: _showGallerySourcePicker,
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
  final Future<void> Function(_DocumentDefinition doc) onCamera;
  final Future<void> Function(_DocumentDefinition doc) onGalleryOrPdf;

  const _DocumentSection({
    required this.title,
    required this.icon,
    required this.docs,
    required this.statusById,
    required this.onCamera,
    required this.onGalleryOrPdf,
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
            const SizedBox(height: 6),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                'File size : max 10 MB',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color.fromARGB(255, 27, 136, 5),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...docs.map((doc) {
              final status =
                  statusById[doc.id] ?? const _DocumentUploadStatus();
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
                                : Icons.cloud_upload_outlined,
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              status.statusText,
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
                                  : () => onCamera(doc),
                              icon: const Icon(Icons.photo_camera_outlined),
                              label: const Text('Camera'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: status.isUploading
                                  ? null
                                  : () => onGalleryOrPdf(doc),
                              icon: const Icon(Icons.upload_file_outlined),
                              label: const Text('Gallery/PDF'),
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
  final int maxSizeMb;

  const _DocumentDefinition({
    required this.id,
    required this.title,
    required this.maxSizeMb,
  });
}

class _DocumentUploadStatus {
  final bool uploadedToServer;
  final bool isUploading;
  final String statusText;

  const _DocumentUploadStatus({
    this.uploadedToServer = false,
    this.isUploading = false,
    this.statusText = 'Not uploaded',
  });

  _DocumentUploadStatus copyWith({
    bool? uploadedToServer,
    bool? isUploading,
    String? statusText,
  }) {
    return _DocumentUploadStatus(
      uploadedToServer: uploadedToServer ?? this.uploadedToServer,
      isUploading: isUploading ?? this.isUploading,
      statusText: statusText ?? this.statusText,
    );
  }
}
