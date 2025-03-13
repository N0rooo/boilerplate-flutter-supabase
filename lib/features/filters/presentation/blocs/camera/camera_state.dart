part of 'camera_bloc.dart';

@immutable
sealed class CameraState {}

final class CameraInitial extends CameraState {}

final class CameraLoading extends CameraState {}

final class CameraReady extends CameraState {
  final CameraController controller;
  CameraReady(this.controller);
}

final class CameraError extends CameraState {
  final String message;
  CameraError(this.message);
}

final class PictureTaken extends CameraState {
  final String imagePath;
  PictureTaken(this.imagePath);
}
