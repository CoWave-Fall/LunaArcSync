import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';

class WebCropperSettings {
  static PlatformUiSettings? get(BuildContext context) {
    return WebUiSettings(
      context: context,
      presentStyle: WebPresentStyle.dialog, //To fix the error, replace 'CropperPresentStyle.dialog' with the correct enum value 'WebPresentStyle.dialog' from the image_cropper package.
      size: const CropperSize(width: 520, height: 520),
    );
  }
}
