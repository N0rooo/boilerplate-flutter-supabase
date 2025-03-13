import 'dart:io';

import 'package:camera/camera.dart';

abstract class CameraRepository {
  Future<List<CameraDescription>> getAvailableCameras();
  Future<void> initializeCamera(CameraDescription camera);
  Future<File> takePicture();
  Future<void> disposeCamera();
  CameraController? get cameraController;
}
