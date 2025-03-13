import 'package:boilerplate_flutter/features/filters/domain/entities/color_filter_preset.dart';
import 'package:boilerplate_flutter/features/filters/domain/repositories/filter_repository.dart';
import 'package:boilerplate_flutter/features/filters/presentation/pages/camera_page.dart';

class UpdateCustomFilter {
  final FilterRepository filterRepository;

  UpdateCustomFilter({required this.filterRepository});

  Future<void> call(ColorFilterPreset filter) async {
    return await filterRepository.updateCustomFilter(filter);
  }
}
