import 'dart:io';
import 'package:image_picker/image_picker.dart';


class ImagePickerService {
  final ImagePicker _picker = ImagePicker();

  Future<File?> pickImageFromGallery() async {
    return _pickImage(ImageSource.gallery);
  }

  Future<File?> pickImageFromCamera() async {
    return _pickImage(ImageSource.camera);
  }

  Future<File?> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        imageQuality: 80, // Compress slightly for performance
      );
      
      if (image != null) {
        return File(image.path);
      }
      return null;
    } catch (e) {
      // Handle or log error
      throw Exception('Failed to pick image: $e');
    }
  }
}
