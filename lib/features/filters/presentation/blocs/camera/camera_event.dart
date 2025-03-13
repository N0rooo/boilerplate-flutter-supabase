part of 'camera_bloc.dart';

@immutable
sealed class CameraEvent {}

class CameraInitialize extends CameraEvent {}

class CameraSwitchCamera extends CameraEvent {}

class CameraTakePicture extends CameraEvent {}

class CameraDispose extends CameraEvent {}
