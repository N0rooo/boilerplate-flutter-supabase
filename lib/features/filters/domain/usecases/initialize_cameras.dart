import 'package:boilerplate_flutter/features/filters/domain/repositories/camera_repository.dart';
import 'package:camera/camera.dart';

class InitializeCameras {
  final CameraRepository cameraRepository;

  InitializeCameras({required this.cameraRepository});

  Future<CameraController> call(CameraDescription camera) async {
    await cameraRepository.initializeCamera(camera);
    return cameraRepository.cameraController!;
  }
}
