import 'dart:io';

import 'package:boilerplate_flutter/core/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ImagePreviewPage extends StatelessWidget {
  final String imagePath;
  const ImagePreviewPage({Key? key, required this.imagePath}) : super(key: key);

  Future<void> _saveImage() async {
    final result = await ImageGallerySaver.saveFile(imagePath);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Preview'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.file(File(imagePath)),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _saveImage,
              child: const Text('Save to Gallery'),
            ),
          ),
        ],
      ),
    );
  }
}
