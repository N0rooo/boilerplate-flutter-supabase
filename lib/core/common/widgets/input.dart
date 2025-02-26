import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final int? maxLines;

  const Input({
    super.key,
    required this.controller,
    required this.hintText,
    this.maxLines,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
      ),
      maxLines: maxLines,
      validator: (value) {
        if (value!.trim().isEmpty) {
          return '$hintText is missing!';
        }
        return null;
      },
    );
  }
}
