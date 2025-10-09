import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:luna_arc_sync/presentation/documents/cubit/document_detail_cubit.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import 'image_editor_unsupported.dart'
    if (dart.library.html) 'image_editor_web.dart';

enum EditableFileType { image, pdf, unsupported }

class EditableFile {
  final String initialPath;
  final EditableFileType type;

  File currentFile;
  Uint8List? displayBytes;
  int rotation = 0;
  double contrast = 100.0;

  EditableFile({required this.initialPath, required this.type})
      : currentFile = File(initialPath);

  Future<void> loadInitialBytes() async {
    if (type == EditableFileType.image) {
      displayBytes = await currentFile.readAsBytes();
    }
  }
}

class BatchImageEditorPage extends StatefulWidget {
  final String documentId;
  final List<String> filePaths;

  const BatchImageEditorPage(
      {super.key, required this.documentId, required this.filePaths});

  @override
  State<BatchImageEditorPage> createState() => _BatchImageEditorPageState();
}

class _BatchImageEditorPageState extends State<BatchImageEditorPage> {
  late List<EditableFile> _files;
  int _selectedIndex = 0;
  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    _files = widget.filePaths.map((path) {
      final extension = p.extension(path).toLowerCase();
      EditableFileType type;
      if (['.jpg', '.jpeg', '.png', '.gif', '.webp'].contains(extension)) {
        type = EditableFileType.image;
      } else if (extension == '.pdf') {
        type = EditableFileType.pdf;
      } else {
        type = EditableFileType.unsupported;
      }
      return EditableFile(initialPath: path, type: type);
    }).toList();
    _loadAllImages();
  }

  Future<void> _loadAllImages() async {
    setState(() => _isProcessing = true);
    for (var file in _files) {
      await file.loadInitialBytes();
    }
    setState(() => _isProcessing = false);
  }

  EditableFile get selectedFile => _files[_selectedIndex];
  bool get isSelectedFileImage => selectedFile.type == EditableFileType.image;

  void _onReorder(int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final item = _files.removeAt(oldIndex);
      _files.insert(newIndex, item);

      if (_selectedIndex == oldIndex) {
        _selectedIndex = newIndex;
      } else if (_selectedIndex > oldIndex && _selectedIndex <= newIndex) {
        _selectedIndex -= 1;
      } else if (_selectedIndex < oldIndex && _selectedIndex >= newIndex) {
        _selectedIndex += 1;
      }
    });
  }

  Future<void> _processImage(EditableFile image,
      {bool highQuality = false}) async {
    if (image.type != EditableFileType.image) return;
    final bytes = await image.currentFile.readAsBytes();

    final processedBytes = await Future(() {
      img.Image? decodedImage = img.decodeImage(bytes);
      if (decodedImage == null) return null;

      if (image.rotation != 0) {
        decodedImage = img.copyRotate(decodedImage, angle: image.rotation);
      }

      if (image.contrast != 100.0) {
        final grayscale = img.grayscale(decodedImage);
        decodedImage = img.contrast(grayscale, contrast: image.contrast);
      }

      return highQuality
          ? img.encodeJpg(decodedImage)
          : img.encodeJpg(decodedImage, quality: 85);
    });

    if (processedBytes != null) {
      setState(() {
        image.displayBytes = processedBytes;
      });
    }
  }

  Future<void> _cropImage() async {
    if (!isSelectedFileImage) return;
    final List<PlatformUiSettings> uiSettings = [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ]),
      IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ]),
    ];

    final webSettings = WebCropperSettings.get(context);
    if (webSettings != null) {
      uiSettings.add(webSettings);
    }

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: selectedFile.currentFile.path,
      uiSettings: uiSettings,
    );

    if (croppedFile != null) {
      setState(() {
        selectedFile.currentFile = File(croppedFile.path);
        selectedFile.rotation = 0;
        selectedFile.contrast = 100.0;
      });
      await _processImage(selectedFile);
    }
  }

  void _rotateImage(int angle) {
    if (!isSelectedFileImage) return;
    setState(() {
      selectedFile.rotation = (selectedFile.rotation + angle) % 360;
    });
    _processImage(selectedFile);
  }

  Future<void> _applyToAll() async {
    if (!isSelectedFileImage) return;
    setState(() => _isProcessing = true);
    final sourceParams = selectedFile;

    for (int i = 0; i < _files.length; i++) {
      if (i == _selectedIndex) continue;
      final targetImage = _files[i];
      if (targetImage.type != EditableFileType.image) continue;
      targetImage.rotation = sourceParams.rotation;
      targetImage.contrast = sourceParams.contrast;
      await _processImage(targetImage);
    }
    setState(() => _isProcessing = false);
  }

  Future<void> _confirmAndUpload() async {
    setState(() => _isProcessing = true);
    final cubit = context.read<DocumentDetailCubit>();
    final tempDir = await getTemporaryDirectory();
    List<String> finalFilePaths = [];

    for (var i = 0; i < _files.length; i++) {
      final fileState = _files[i];
      if (fileState.type == EditableFileType.image) {
        // Ensure final quality processing is done for images
        await _processImage(fileState, highQuality: true);
        final finalFile = File(
            '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch + i}.jpg');
        await finalFile.writeAsBytes(fileState.displayBytes!);
        finalFilePaths.add(finalFile.path);
      } else if (fileState.type == EditableFileType.pdf) {
        // For PDFs, just use the original path
        finalFilePaths.add(fileState.initialPath);
      }
    }

    try {
      await cubit.uploadPages(
          documentId: widget.documentId, filePaths: finalFilePaths);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Upload successful!'),
              backgroundColor: Colors.green),
        );
        Navigator.of(context).pop(true); // Pop with success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Upload failed: $e'),
              backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_files.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Edit & Upload')),
        body: const Center(child: Text('No files selected.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit & Upload (${_selectedIndex + 1}/${_files.length})'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _isProcessing ? null : _confirmAndUpload,
            tooltip: 'Confirm and Upload',
          )
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Colors.black87,
              child: Center(
                child: _isProcessing
                    ? const CircularProgressIndicator()
                    : _buildPreview(),
              ),
            ),
          ),
          if (isSelectedFileImage)
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.crop),
                          onPressed: _isProcessing ? null : _cropImage,
                          tooltip: 'Crop Image'),
                      IconButton(
                          icon: const Icon(Icons.rotate_left),
                          onPressed: _isProcessing ? null : () => _rotateImage(-90),
                          tooltip: 'Rotate Left'),
                      IconButton(
                          icon: const Icon(Icons.rotate_right),
                          onPressed: _isProcessing ? null : () => _rotateImage(90),
                          tooltip: 'Rotate Right'),
                      TextButton(
                          onPressed: _isProcessing ? null : _applyToAll,
                          child: const Text('Apply to All')),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                      'Scan Filter Contrast: ${selectedFile.contrast.toInt()}'),
                  Slider(
                    value: selectedFile.contrast,
                    min: 0,
                    max: 200,
                    label: selectedFile.contrast.toInt().toString(),
                    onChanged: (value) =>
                        setState(() => selectedFile.contrast = value),
                    onChangeEnd: (value) => _processImage(selectedFile),
                  ),
                ],
              ),
            ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.grey[300],
              child: ReorderableListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _files.length,
                itemBuilder: (context, index) {
                  final file = _files[index];
                  return GestureDetector(
                    key: ValueKey(file.initialPath),
                    onTap: () => setState(() => _selectedIndex = index),
                    child: Container(
                      width: 100,
                      margin: const EdgeInsets.all(4.0),
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: _selectedIndex == index
                                ? Colors.blue
                                : Colors.transparent,
                            width: 3),
                      ),
                      child: _buildThumbnail(file),
                    ),
                  );
                },
                onReorder: _onReorder,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPreview() {
    final file = selectedFile;
    switch (file.type) {
      case EditableFileType.image:
        return file.displayBytes == null
            ? const CircularProgressIndicator()
            : Image.memory(file.displayBytes!);
      case EditableFileType.pdf:
        return const Icon(Icons.picture_as_pdf, color: Colors.white, size: 100);
      case EditableFileType.unsupported:
        return const Icon(Icons.error, color: Colors.red, size: 100);
    }
  }

  Widget _buildThumbnail(EditableFile file) {
    switch (file.type) {
      case EditableFileType.image:
        return file.displayBytes == null
            ? const Center(child: CircularProgressIndicator())
            : Image.memory(file.displayBytes!, fit: BoxFit.cover);
      case EditableFileType.pdf:
        return const Center(
            child: Icon(Icons.picture_as_pdf, size: 48, color: Colors.red));
      case EditableFileType.unsupported:
        return const Center(
            child: Icon(Icons.error, size: 48, color: Colors.grey));
    }
  }
}
