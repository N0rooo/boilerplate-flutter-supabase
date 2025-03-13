import 'package:boilerplate_flutter/features/filters/domain/entities/color_filter_preset.dart';
import 'package:boilerplate_flutter/features/filters/presentation/pages/camera_page.dart';

abstract class FilterRepository {
  Future<List<ColorFilterPreset>> getPresetFilters();
  Future<void> saveCustomFilter(ColorFilterPreset filter);
  Future<List<ColorFilterPreset>> getSavedCustomFilters();
}
