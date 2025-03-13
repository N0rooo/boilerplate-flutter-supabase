import 'package:boilerplate_flutter/features/filters/domain/entities/color_filter_preset.dart';
import 'package:boilerplate_flutter/features/filters/domain/repositories/filter_repository.dart';
import 'package:boilerplate_flutter/features/filters/presentation/pages/camera_page.dart';

class GetFilterPresets {
  final FilterRepository filterRepository;

  GetFilterPresets({required this.filterRepository});

  Future<List<ColorFilterPreset>> call() async {
    List<ColorFilterPreset> presets = await filterRepository.getPresetFilters();
    List<ColorFilterPreset> customFilters =
        await filterRepository.getSavedCustomFilters();
    return [...presets, ...customFilters];
  }
}
