import 'dart:io';

import 'package:boilerplate_flutter/features/filters/domain/repositories/camera_repository.dart';

class TakePicture {
  final CameraRepository cameraRepository;

  TakePicture({required this.cameraRepository});

  Future<File> call() async {
    return await cameraRepository.takePicture();
  }
}
