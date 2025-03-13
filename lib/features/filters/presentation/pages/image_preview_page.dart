import 'dart:io';

import 'package:boilerplate_flutter/core/utils/show_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class ImagePreviewPage extends StatelessWidget {
  final String imagePath;
  const ImagePreviewPage({Key? key, required this.imagePath}) : super(key: key);

  Future<void> _saveImage(BuildContext context) async {
    final result = await ImageGallerySaver.saveFile(imagePath);
    if (result['isSuccess']) {
      showSnackBar(context, 'Image saved to gallery');
    } else {
      showSnackBar(context, 'Failed to save image');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Preview'),
        actions: [
          IconButton(
            onPressed: () => _saveImage(context),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.file(File(imagePath)),
          ),
        ],
      ),
    );
  }
}
