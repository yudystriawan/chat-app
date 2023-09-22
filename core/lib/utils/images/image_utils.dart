import 'dart:developer';
import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// An enum to represent the source of the image (camera or gallery).
enum ImageOrigin {
  camera,
  gallery;

  /// Returns true if the image source is the camera.
  bool get isCamera => this == ImageOrigin.camera;

  /// Returns true if the image source is the gallery.
  bool get isGallery => this == ImageOrigin.gallery;
}

/// Extension on [ImageOrigin] to convert it to an [ImageSource] enum from image_picker.
extension ImageSourceX on ImageOrigin {
  /// Converts [ImageOrigin] to [ImageSource].
  ImageSource convertToImageSource() {
    if (this == ImageOrigin.camera) return ImageSource.camera;

    return ImageSource.gallery;
  }
}

/// A utility class for working with images in a Flutter app.
class ImageUtils {
  /// Picks an image from either the camera or gallery.
  ///
  /// Returns a [File] representing the picked image, or null if the user cancels.
  static Future<File?> pickImage(ImageOrigin origin) async {
    try {
      final picker = ImagePicker();
      final pickedFile = await picker.pickImage(
        source: origin.convertToImageSource(),
      );

      if (pickedFile == null) return null;

      return File(pickedFile.path);
    } catch (e, s) {
      log('an error occured', name: 'pickImage', error: e, stackTrace: s);
      return null;
    }
  }

  /// Crops an image with optional width and height constraints.
  ///
  /// Returns a [File] representing the cropped image, or null if the user cancels.
  static Future<File?> cropImage(
    String sourcePath, {
    double? width,
    double? height,
  }) async {
    try {
      final croppedImage = await ImageCropper().cropImage(
        sourcePath: sourcePath,
        aspectRatio: const CropAspectRatio(
          ratioX: 1,
          ratioY: 1,
        ),
      );

      if (croppedImage == null) return null;

      return File(croppedImage.path);
    } catch (e, s) {
      log('an error occured', name: 'cropImage', error: e, stackTrace: s);
      return null;
    }
  }

  /// Compresses an image with an optional quality parameter.
  ///
  /// Returns a [File] representing the compressed image, or null if compression fails.
  static Future<File?> compressImage(
    String sourcePath, {
    int quality = 70,
  }) async {
    try {
      final directory = await getTemporaryDirectory();

      String targetPath = p.join(directory.path,
          '${DateTime.now().toIso8601String()}.${p.extension(sourcePath)}');

      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        sourcePath,
        targetPath,
        quality: quality,
      );

      if (compressedFile == null) return null;

      return File(compressedFile.path);
    } catch (e, s) {
      log('an error occured', name: 'compressImage', error: e, stackTrace: s);
      return null;
    }
  }
}
