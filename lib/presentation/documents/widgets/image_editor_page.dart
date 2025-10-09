
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';



// Add this function to provide web UI settings if available
PlatformUiSettings? getWebUiSettings(BuildContext context) {
  // If running on web, you may want to return specific settings.
  // Otherwise, return null.
  // You can customize this function as needed for your project.
  return null;
}


class ImageEditorPage extends StatefulWidget {
  final String imagePath;

  const ImageEditorPage({super.key, required this.imagePath});

  @override
  State<ImageEditorPage> createState() => _ImageEditorPageState();
}

class _ImageEditorPageState extends State<ImageEditorPage> {
  late File _imageFile;
  img.Image? _workingImage;
  Uint8List? _displayBytes;

  double _contrastLevel = 100.0;
  bool _isProcessing = false;

  int _currentRotation = 0;

  @override
  void initState() {
    super.initState();
    _imageFile = File(widget.imagePath);
    _loadImage();
  }

  Future<void> _loadImage() async {
    setState(() => _isProcessing = true);
    final bytes = await _imageFile.readAsBytes();
    _workingImage = img.decodeImage(bytes);
    _displayBytes = bytes;
    _currentRotation = 0; // Reset rotation on new image/crop
    setState(() => _isProcessing = false);
  }

  Future<void> _cropImage() async {
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
        ],
      ),
    ];

    final webSettings = getWebUiSettings(context);
    if (webSettings != null) {
      uiSettings.add(webSettings);
    }

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: _imageFile.path,
      uiSettings: uiSettings,
    );

    if (croppedFile != null) {
      _imageFile = File(croppedFile.path);
      await _loadImage();
    }
  }

  

  void _rotateLeft() {
    _rotateImage(-90);
  }

  void _rotateRight() {
    _rotateImage(90);
  }

  void _rotateImage(int angle) {
    if (_workingImage == null) return;
    setState(() => _isProcessing = true);

    _currentRotation = (_currentRotation + angle) % 360;
    _workingImage = img.copyRotate(_workingImage!, angle: angle);
    _displayBytes = Uint8List.fromList(img.encodeJpg(_workingImage!));

    setState(() => _isProcessing = false);
  }

  Future<void> _applyScanFilter() async {
    if (_workingImage == null) return;
    setState(() => _isProcessing = true);

    // Use a background isolate for image processing to avoid UI freeze
    final originalBytes = await _imageFile.readAsBytes();
    final args = {
      'bytes': originalBytes,
      'rotation': _currentRotation,
      'contrast': _contrastLevel,
    };

    // This is a simplified way. For a real app, use compute or a dedicated isolate manager.
    final processedBytes = await Future(() {
      img.Image? imageToProcess = img.decodeImage(args['bytes'] as Uint8List);
      if (imageToProcess != null) {
        if (args['rotation'] as int != 0) {
          imageToProcess = img.copyRotate(imageToProcess, angle: args['rotation'] as int);
        }
        final grayscaleImage = img.grayscale(imageToProcess);
        final contrastedImage = img.contrast(grayscaleImage, contrast: args['contrast'] as double);
        return Uint8List.fromList(img.encodeJpg(contrastedImage));
      }
      return null;
    });

    if (processedBytes != null) {
      _workingImage = img.decodeImage(processedBytes);
      _displayBytes = processedBytes;
    }

    setState(() => _isProcessing = false);
  }


  Future<void> _applyAndConfirm() async {
    if (_workingImage == null) return;
    setState(() => _isProcessing = true);

    final tempDir = await getTemporaryDirectory();
    final finalFile = File(
        '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg');
    await finalFile.writeAsBytes(img.encodeJpg(_workingImage!));

    setState(() => _isProcessing = false);
    if (mounted) {
      Navigator.of(context).pop(finalFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: SizedBox(
        width: 600, // Constrain width for dialog format
        height: 800, // Constrain height for dialog format
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Edit Image', style: Theme.of(context).textTheme.titleLarge),
                ),
                Expanded(
                  child: Center(
                    child: _displayBytes == null
                        ? const CircularProgressIndicator()
                        : Image.memory(_displayBytes!),
                  ),
                ),
                // Toolbar
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Basic editing actions
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.crop),
                            onPressed: _isProcessing ? null : _cropImage,
                            tooltip: 'Crop Image',
                          ),
                          
                          IconButton(
                            icon: const Icon(Icons.rotate_left),
                            onPressed: _isProcessing ? null : _rotateLeft,
                            tooltip: 'Rotate Left',
                          ),
                          IconButton(
                            icon: const Icon(Icons.rotate_right),
                            onPressed: _isProcessing ? null : _rotateRight,
                            tooltip: 'Rotate Right',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      // Scan Filter
                      Text('Scan Filter Contrast: ${_contrastLevel.toInt()}'),
                      Slider(
                        value: _contrastLevel,
                        min: 0,
                        max: 200,
                        divisions: 200,
                        label: _contrastLevel.toInt().toString(),
                        onChanged: (value) {
                          setState(() {
                            _contrastLevel = value;
                          });
                        },
                        onChangeEnd: (value) {
                          _applyScanFilter();
                        },
                      ),
                    ],
                  ),
                ),
                // Action Buttons
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _isProcessing ? null : _applyAndConfirm,
                        child: const Text('Confirm'),
                      ),
                    ],
                  ),
                )
              ],
            ),
            if (_isProcessing)
              Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

