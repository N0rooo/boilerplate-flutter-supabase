import 'dart:io';

import 'package:boilerplate_flutter/features/filters/domain/repositories/camera_repository.dart';
import 'package:camera/camera.dart';
import 'package:camera/src/camera_controller.dart';
import 'package:camera_platform_interface/src/types/camera_description.dart';

class CameraRepositoryImpl implements CameraRepository {
  CameraController? _cameraController;

  @override
  CameraController? get cameraController => _cameraController;

  @override
  Future<List<CameraDescription>> getAvailableCameras() async {
    return await availableCameras();
  }

  @override
  Future<CameraController> initializeCamera(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
    );
    await _cameraController!.initialize();
    return _cameraController!;
  }

  @override
  Future<File> takePicture() async {
    final XFile image = await _cameraController!.takePicture();
    return File(image.path);
  }

  @override
  Future<void> disposeCamera() async {
    if (_cameraController == null) {
      print('No camera to dispose.');
      return;
    }

    if (!_cameraController!.value.isInitialized) {
      print('Camera controller is not initialized.');
      return;
    }

    try {
      await _cameraController!.dispose();
      _cameraController = null;
      print('Camera disposed successfully.');
    } catch (e) {
      print('Error disposing camera: $e');
      throw Exception('Failed to dispose camera');
    }
  }
}
