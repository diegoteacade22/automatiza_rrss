import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerService {
  static final ImagePicker _picker = ImagePicker();

  static Future<bool> requestPermissions() async {
    try {
      // En web, los permisos se manejan automáticamente por el navegador
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Error requesting permissions: $e');
      }
      return false;
    }
  }

  static Future<File?> pickImageFromGallery() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error picking image from gallery: $e');
      }
      return null;
    }
  }

  static Future<File?> pickImageFromCamera() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        return File(pickedFile.path);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error picking image from camera: $e');
      }
      return null;
    }
  }

  static Future<File?> pickMultipleImages() async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        // Return the first image for now, can be extended to handle multiple
        return File(pickedFiles.first.path);
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error picking multiple images: $e');
      }
      return null;
    }
  }

  // Versión web simplificada sin recorte de imágenes
  static Future<File?> cropImage(File imageFile) async {
    // En web, retornamos la imagen sin recortar
    // Esto puede ser mejorado con un editor de imágenes web en el futuro
    return imageFile;
  }

  static Future<List<File>?> pickAndCropMultipleImages() async {
    try {
      final List<XFile>? pickedFiles = await _picker.pickMultiImage(
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (pickedFiles != null && pickedFiles.isNotEmpty) {
        List<File> images = [];
        
        for (var file in pickedFiles) {
          File imageFile = File(file.path);
          images.add(imageFile);
        }
        
        return images;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error picking multiple images: $e');
      }
      return null;
    }
  }
}