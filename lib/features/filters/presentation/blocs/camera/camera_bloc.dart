import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/features/filters/domain/repositories/camera_repository.dart';
import 'package:camera/camera.dart';
import 'package:meta/meta.dart';

part 'camera_event.dart';
part 'camera_state.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final CameraRepository _cameraRepository;
  List<CameraDescription> _cameras = [];
  int _currentCameraIndex = 0;

  CameraBloc(this._cameraRepository) : super(CameraInitial()) {
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
      _cameras = await _cameraRepository.getAvailableCameras();
      if (_cameras.isNotEmpty) {
        await _cameraRepository.initializeCamera(_cameras[_currentCameraIndex]);
        emit(CameraReady(_cameraRepository.cameraController!));
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
      await _cameraRepository.disposeCamera();
      _currentCameraIndex = (_currentCameraIndex + 1) % _cameras.length;
      await _cameraRepository.initializeCamera(_cameras[_currentCameraIndex]);
      emit(CameraReady(_cameraRepository.cameraController!));
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
      final file = await _cameraRepository.takePicture();
      emit(PictureTaken(file.path));
      print('Picture taken: ${file.path}');
      emit(CameraReady(_cameraRepository.cameraController!));
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
    await _cameraRepository.disposeCamera();
    emit(CameraInitial());
  }

  @override
  Future<void> close() {
    _cameraRepository.disposeCamera();
    return super.close();
  }
}
