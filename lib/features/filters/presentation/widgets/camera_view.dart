import 'package:boilerplate_flutter/core/theme/app_palette.dart';
import 'package:boilerplate_flutter/features/filters/presentation/blocs/filter/filter_bloc.dart';
import 'package:boilerplate_flutter/features/filters/presentation/pages/image_preview_page.dart';
import 'package:boilerplate_flutter/features/filters/presentation/widgets/camera_controls.dart';
import 'package:boilerplate_flutter/features/filters/presentation/widgets/filter_selection.dart';
import 'package:boilerplate_flutter/features/filters/presentation/widgets/show_filter_button.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:boilerplate_flutter/features/filters/presentation/blocs/camera/camera_bloc.dart';
import 'dart:io';
import 'package:image/image.dart' as img;

class Filter {
  final String name;
  final List<double> matrix;

  Filter({required this.name, required this.matrix});
}

class CameraView extends StatefulWidget {
  final CameraController controller;
  final FilterState filterState;

  const CameraView(
      {Key? key, required this.controller, required this.filterState})
      : super(key: key);

  @override
  _CameraViewState createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView> {
  double _filterIntensity = 1.0;
  int _selectedFilterIndex = 0;

  Future<void> _captureImageWithFilter() async {
    final image = await widget.controller.takePicture();

    final filteredImagePath = await _applyFilterToImage(image.path);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ImagePreviewPage(imagePath: filteredImagePath),
      ),
    );
  }

  Future<String> _applyFilterToImage(String imagePath) async {
    // Load the image
    final originalImage = img.decodeImage(File(imagePath).readAsBytesSync());

    if (originalImage == null) {
      throw Exception('Failed to load image');
    }

    final filteredImage = img.Image.from(originalImage);

    final filterMatrix =
        context.read<FilterBloc>().getAdjustedMatrix(_filterIntensity);

    for (int y = 0; y < filteredImage.height; y++) {
      for (int x = 0; x < filteredImage.width; x++) {
        final pixel = filteredImage.getPixel(x, y);

        final r = img.getRed(pixel);
        final g = img.getGreen(pixel);
        final b = img.getBlue(pixel);
        final a = img.getAlpha(pixel);

        final newR = _applyMatrixToColor(filterMatrix, 0, r, g, b, a);
        final newG = _applyMatrixToColor(filterMatrix, 5, r, g, b, a);
        final newB = _applyMatrixToColor(filterMatrix, 10, r, g, b, a);
        // final newA = _applyMatrixToColor(filterMatrix, 15, r, g, b, a);
        final newA = a;

        filteredImage.setPixel(x, y, img.getColor(newR, newG, newB, newA));
      }
    }

    final filteredImagePath = '${imagePath}_filtered.png';
    File(filteredImagePath).writeAsBytesSync(img.encodePng(filteredImage));

    return filteredImagePath;
  }

  int _applyMatrixToColor(
      List<double> matrix, int start, int r, int g, int b, int a) {
    return (matrix[start] * r +
            matrix[start + 1] * g +
            matrix[start + 2] * b +
            matrix[start + 3] * a +
            matrix[start + 4])
        .clamp(0, 255)
        .toInt();
  }

  @override
  Widget build(BuildContext context) {
    final _filters = widget.filterState.filters;
    _filterIntensity = widget.filterState.filterIntensity;
    final adjustedMatrix =
        context.read<FilterBloc>().getAdjustedMatrix(_filterIntensity);

    return Stack(
      children: [
        Positioned.fill(
          child: ColorFiltered(
            colorFilter: ColorFilter.matrix(adjustedMatrix),
            child: CameraPreview(widget.controller),
          ),
        ),
        Positioned(
          bottom: 10,
          right: 10,
          child: IconButton(
            icon: Icon(Icons.switch_camera, color: Colors.white),
            onPressed: () {
              context.read<CameraBloc>().add(CameraSwitchCamera());
            },
          ),
        ),
        SafeArea(
          child: Column(
            children: [
              Expanded(child: Container()),
              if (widget.filterState.isFilterActive)
                // Filter intensity slider
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      const Text(
                        'Intensity:',
                        style: TextStyle(
                          color: AppPallete.whiteColor,
                        ),
                      ),
                      Expanded(
                        child: Slider(
                          value: _filterIntensity,
                          min: 0,
                          max: 1,
                          onChanged: (value) {
                            setState(() {
                              _filterIntensity = value;
                            });
                            context
                                .read<FilterBloc>()
                                .add(FilterSetIntensity(value));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              if (widget.filterState.isFilterActive)
                // Filter selection
                FilterSelection(
                  filters: _filters,
                  selectedFilterIndex: _selectedFilterIndex,
                  onFilterSelected: (index) {
                    setState(() {
                      _selectedFilterIndex = index;
                    });
                    context.read<FilterBloc>().add(FilterSelect(index));
                  },
                ),
              const SizedBox(height: 10),
              ShowFilterButton(filterState: widget.filterState),
              CameraControls(onCapture: _captureImageWithFilter),
            ],
          ),
        ),
      ],
    );
  }
}
