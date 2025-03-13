import 'package:boilerplate_flutter/features/filters/domain/repositories/camera_repository.dart';
import 'package:camera/camera.dart';

class GetAvailableCameras {
  final CameraRepository cameraRepository;

  GetAvailableCameras({required this.cameraRepository});

  Future<List<CameraDescription>> call() async {
    return await cameraRepository.getAvailableCameras();
  }
}
