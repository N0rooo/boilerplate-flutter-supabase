import 'dart:async';
import 'package:flutter/material.dart';

mixin Debouncer<T extends StatefulWidget> on State<T> {
  Timer? _debounceTimer;

  void debounce(
    VoidCallback action, {
    Duration duration = const Duration(milliseconds: 500),
  }) {
    if (_debounceTimer?.isActive ?? false) _debounceTimer!.cancel();
    _debounceTimer = Timer(duration, action);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}
