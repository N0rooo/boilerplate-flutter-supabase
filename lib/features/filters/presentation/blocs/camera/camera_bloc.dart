import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/features/filters/domain/repositories/camera_repository.dart';
import 'package:boilerplate_flutter/features/filters/domain/usecases/dispose_cameras.dart';
import 'package:boilerplate_flutter/features/filters/domain/usecases/get_available_cameras.dart';
import 'package:boilerplate_flutter/features/filters/domain/usecases/initialize_cameras.dart';
import 'package:boilerplate_flutter/features/filters/domain/usecases/take_picture.dart';
import 'package:camera/camera.dart';
import 'package:meta/meta.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final GetAvailableCameras getAvailableCameras;
  final InitializeCameras initializeCameras;
  final DisposeCameras disposeCameras;
  final TakePicture takePicture;
  List<CameraDescription> _cameras = [];
  int _currentCameraIndex = 0;

  CameraBloc({
    required this.getAvailableCameras,
    required this.initializeCameras,
    required this.disposeCameras,
    required this.takePicture,
  }) : super(CameraInitial()) {
    on<CameraInitialize>(_onCameraInitialize);
    on<CameraSwitchCamera>(_onCameraSwitchCamera);
    on<CameraTakePicture>(_onCameraTakePicture);
    on<CameraDispose>(_onCameraDispose);
  }

  Future<void> _onCameraInitialize(
    CameraInitialize event,
    Emitter<CameraState> emit,
  ) async {
    emit(CameraLoading());
    try {
      _cameras = await getAvailableCameras();
      if (_cameras.isNotEmpty) {
        final cameraController =
            await initializeCameras(_cameras[_currentCameraIndex]);
        emit(CameraReady(cameraController));
      } else {
        emit(CameraError('No cameras available'));
      }
    } catch (e) {
      if (e is CameraException) {
        print('Error initializing camera: $e');
      }
      emit(CameraError(e.toString()));
    }
  }

  Future<void> _onCameraSwitchCamera(
    CameraSwitchCamera event,
    Emitter<CameraState> emit,
  ) async {
    if (_cameras.length < 2) {
      return;
    }

    emit(CameraLoading());
    try {
      print('Disposing cameras');
      await disposeCameras();
      print('Disposed cameras');
      print('Initializing cameras');
      _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;
      final cameraController =
          await initializeCameras(_cameras[_currentCameraIndex]);
      emit(CameraReady(cameraController));
      print('Camera ready');
    } catch (e) {
      if (e is CameraException) {
        print('Error switching camera: $e');
      }
      emit(CameraError(e.toString()));
    }
  }

  Future<void> _onCameraTakePicture(
    CameraTakePicture event,
    Emitter<CameraState> emit,
  ) async {
    try {
      final file = await takePicture();
      emit(PictureTaken(file.path));
      final cameraController =
          await initializeCameras(_cameras[_currentCameraIndex]);
      print('Picture taken: ${file.path}');
      emit(CameraReady(cameraController));
    } catch (e) {
      if (e is CameraException) {
        print('Error taking picture: $e');
      }
      emit(CameraError(e.toString()));
    }
  }

  Future<void> _onCameraDispose(
    CameraDispose event,
    Emitter<CameraState> emit,
  ) async {
    await disposeCameras();
    emit(CameraInitial());
  }

  @override
  Future<void> close() {
    disposeCameras();
    return super.close();
  }
}
