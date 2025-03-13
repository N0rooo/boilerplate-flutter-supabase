import 'package:boilerplate_flutter/core/theme/app_palette.dart';
import 'package:boilerplate_flutter/features/filters/presentation/blocs/filter/filter_bloc.dart';
import 'package:boilerplate_flutter/features/filters/presentation/pages/image_preview_page.dart';
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
                SizedBox(
                  height: 100,
                  child: Row(
                    children: [
                      // Capture button

                      // Filter list
                      Expanded(
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: _filters.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedFilterIndex = index;
                                });
                                context
                                    .read<FilterBloc>()
                                    .add(FilterSelect(index));
                              },
                              child: ClipRRect(
                                child: Container(
                                  width: 80,
                                  margin: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: _selectedFilterIndex == index
                                          ? AppPallete.gradient1
                                          : AppPallete.whiteColor,
                                      width:
                                          _selectedFilterIndex == index ? 3 : 1,
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      // Filter preview
                                      Positioned.fill(
                                        child: ColorFiltered(
                                          colorFilter: ColorFilter.matrix(
                                              _filters[index].matrix),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade800,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomCenter,
                                        child: Container(
                                          color: Colors.black54,
                                          width: double.infinity,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: Text(
                                            _filters[index].name,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(
                                                color: AppPallete.whiteColor,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  context.read<FilterBloc>().add(FilterToggle());
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                  decoration: BoxDecoration(
                    color: AppPallete.gradient1,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Text(
                    widget.filterState.isFilterActive
                        ? "Hide Filters"
                        : "Show Filters",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: _captureImageWithFilter,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 62,
                            height: 62,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              border: Border.all(
                                color: AppPallete.whiteColor,
                                width: 2,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                          Container(
                            width: 56,
                            height: 56,
                            decoration: BoxDecoration(
                              color: AppPallete.whiteColor,
                              border: Border.all(
                                color: Colors.black,
                                width: 1,
                              ),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Switch camera button

                    // Flash toggle button
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

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

    // Create a new image with the same dimensions
    final filteredImage = img.Image.from(originalImage);

    // Get the filter matrix
    final filterMatrix =
        widget.filterState.filters[_selectedFilterIndex].matrix;

    // Apply the filter matrix to each pixel
    for (int y = 0; y < filteredImage.height; y++) {
      for (int x = 0; x < filteredImage.width; x++) {
        final pixel = filteredImage.getPixel(x, y);

        // Extract the color components
        final r = img.getRed(pixel);
        final g = img.getGreen(pixel);
        final b = img.getBlue(pixel);
        final a = img.getAlpha(pixel);

        // Apply the filter matrix
        final newR = (filterMatrix[0] * r +
                filterMatrix[1] * g +
                filterMatrix[2] * b +
                filterMatrix[3] * a +
                filterMatrix[4])
            .clamp(0, 255)
            .toInt();
        final newG = (filterMatrix[5] * r +
                filterMatrix[6] * g +
                filterMatrix[7] * b +
                filterMatrix[8] * a +
                filterMatrix[9])
            .clamp(0, 255)
            .toInt();
        final newB = (filterMatrix[10] * r +
                filterMatrix[11] * g +
                filterMatrix[12] * b +
                filterMatrix[13] * a +
                filterMatrix[14])
            .clamp(0, 255)
            .toInt();
        final newA = (filterMatrix[15] * r +
                filterMatrix[16] * g +
                filterMatrix[17] * b +
                filterMatrix[18] * a +
                filterMatrix[19])
            .clamp(0, 255)
            .toInt();

        // Set the new pixel value
        filteredImage.setPixel(x, y, img.getColor(newR, newG, newB, newA));
      }
    }

    // Save the filtered image to a new file
    final filteredImagePath = '${imagePath}_filtered.png';
    File(filteredImagePath).writeAsBytesSync(img.encodePng(filteredImage));

    return filteredImagePath;
  }
}
