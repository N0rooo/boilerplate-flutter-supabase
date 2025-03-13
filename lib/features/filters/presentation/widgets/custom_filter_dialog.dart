import 'package:boilerplate_flutter/features/filters/domain/entities/color_filter_preset.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class CustomFilterDialog extends StatelessWidget {
  final Function(ColorFilterPreset) onSave;
  const CustomFilterDialog({super.key, required this.onSave});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
