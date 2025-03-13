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
  Future<void> initializeCamera(CameraDescription camera) async {
    _cameraController = CameraController(
      camera,
      ResolutionPreset.high,
    );
    await _cameraController!.initialize();
  }

  @override
  Future<File> takePicture() async {
    final XFile image = await _cameraController!.takePicture();
    return File(image.path);
  }

  @override
  Future<void> disposeCamera() async {
    await _cameraController!.dispose();
    _cameraController = null;
  }
}
