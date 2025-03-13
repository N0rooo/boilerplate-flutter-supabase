import 'package:boilerplate_flutter/features/filters/domain/repositories/camera_repository.dart';

class DisposeCameras {
  final CameraRepository cameraRepository;

  DisposeCameras({required this.cameraRepository});

  Future<void> call() async {
    await cameraRepository.disposeCamera();
  }
}
