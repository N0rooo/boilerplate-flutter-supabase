import 'package:boilerplate_flutter/core/theme/app_palette.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CameraControls extends StatelessWidget {
  final Function() onCapture;
  const CameraControls({super.key, required this.onCapture});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: onCapture,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    border: Border.all(
                      color: AppPalette.whiteColor,
                      width: 2,
                    ),
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: AppPalette.whiteColor,
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
    );
  }
}
