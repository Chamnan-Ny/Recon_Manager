import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

// Wraps the image_picker plugin so screens don't need to deal with
// ImagePicker/XFile directly. Returns raw bytes (not a dart:io File) -
// dart:io File isn't available on Flutter Web, and the rest of the app
// (compression, Base64 encode, Firestore upload) already works on bytes.
class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  // Pick image from gallery. Returns null if the user cancels.
  Future<Uint8List?> pickImageFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return null;
      return await image.readAsBytes();
    } catch (e) {
      rethrow;
    }
  }

  // Capture image from camera. Returns null if the user cancels.
  Future<Uint8List?> captureImageFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (image == null) return null;
      return await image.readAsBytes();
    } catch (e) {
      rethrow;
    }
  }
}
