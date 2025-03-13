import 'package:boilerplate_flutter/features/filters/domain/entities/color_filter_preset.dart';
import 'package:boilerplate_flutter/features/filters/domain/repositories/filter_repository.dart';

class DeleteCustomFilter {
  final FilterRepository filterRepository;

  DeleteCustomFilter({required this.filterRepository});

  Future<void> call(ColorFilterPreset filter) async {
    return await filterRepository.deleteCustomFilter(filter);
  }
}
