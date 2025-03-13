import 'package:boilerplate_flutter/features/filters/presentation/widgets/camera_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:boilerplate_flutter/features/filters/presentation/blocs/camera/camera_bloc.dart';
import 'package:boilerplate_flutter/features/filters/presentation/blocs/filter/filter_bloc.dart';
import 'package:boilerplate_flutter/features/filters/presentation/widgets/custom_filter_dialog.dart';
import 'package:boilerplate_flutter/features/filters/presentation/pages/image_preview_page.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  @override
  void initState() {
    super.initState();
    initializeCamera();
  }

  void initializeCamera() {
    context.read<CameraBloc>().add(CameraInitialize());
    context.read<FilterBloc>().add(FilterLoad());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<CameraBloc, CameraState>(
        builder: _cameraStateBuilder,
      ),
    );
  }

  Widget _cameraStateBuilder(BuildContext context, CameraState cameraState) {
    print("cameraState: $cameraState");
    if (cameraState is CameraLoading || cameraState is CameraInitial) {
      return const Center(child: CircularProgressIndicator());
    } else if (cameraState is CameraError) {
      return Center(
        child: Text(
          'Error: ${cameraState.message}',
          style: const TextStyle(color: Colors.white),
        ),
      );
    } else if (cameraState is CameraReady) {
      return _buildCameraView(context, cameraState.controller);
    } else {
      return const Center(
        child: Text(
          'Unexpected state',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  Widget _buildCameraView(BuildContext context, CameraController controller) {
    return BlocBuilder<FilterBloc, FilterState>(
      builder: (context, filterState) {
        return CameraView(controller: controller, filterState: filterState);
      },
    );
  }

  @override
  void dispose() {
    context.read<CameraBloc>().add(CameraDispose());
    super.dispose();
  }
}
