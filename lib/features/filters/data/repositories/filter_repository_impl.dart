import 'dart:convert';

import 'package:boilerplate_flutter/features/filters/domain/entities/color_filter_preset.dart';
import 'package:boilerplate_flutter/features/filters/domain/repositories/filter_repository.dart';
import 'package:boilerplate_flutter/features/filters/presentation/pages/camera_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class FilterRepositoryImpl implements FilterRepository {
  static const String _customFiltersKey = 'custom_filters';
  final Uuid _uuid = const Uuid();

  @override
  Future<List<ColorFilterPreset>> getPresetFilters() async {
    // Hardcoded preset filters
    return [
      ColorFilterPreset(
        id: 'normal',
        name: 'Normal',
        matrix: [
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ],
      ),
      ColorFilterPreset(
        id: 'sepia',
        name: 'Sepia',
        matrix: [
          0.393,
          0.769,
          0.189,
          0,
          0,
          0.349,
          0.686,
          0.168,
          0,
          0,
          0.272,
          0.534,
          0.131,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ],
      ),
      ColorFilterPreset(id: 'greyscale', name: 'Greyscale', matrix: [
        0.3,
        0.59,
        0.11,
        0,
        0,
        0.3,
        0.59,
        0.11,
        0,
        0,
        0.3,
        0.59,
        0.11,
        0,
        0,
        0,
        0,
        0,
        1,
        0
      ]),
      ColorFilterPreset(
        id: 'dark',
        name: 'Dark',
        matrix: [
          0.5,
          0,
          0,
          0,
          0,
          0,
          0.5,
          0,
          0,
          0,
          0,
          0,
          0.5,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ],
      ),
      ColorFilterPreset(
        id: 'vintage',
        name: 'Vintage',
        matrix: [
          0.9,
          0.5,
          0.1,
          0,
          0,
          0.3,
          0.8,
          0.1,
          0,
          0,
          0.2,
          0.3,
          0.5,
          0,
          0,
          0,
          0,
          0,
          1,
          0,
        ],
      ),
      // Add more preset filters as desired
    ];
  }

  @override
  Future<void> saveCustomFilter(ColorFilterPreset filter) async {
    final prefs = await SharedPreferences.getInstance();
    final List<ColorFilterPreset> existingFilters =
        await getSavedCustomFilters();

    final newFilter = filter.id.isEmpty
        ? ColorFilterPreset(
            id: _uuid.v4(),
            name: filter.name,
            matrix: filter.matrix,
          )
        : filter;

    existingFilters.add(newFilter);

    // Convert to JSON and save
    final List<String> jsonList = existingFilters
        .map((filter) => jsonEncode({
              'id': filter.id,
              'name': filter.name,
              'matrix': filter.matrix,
            }))
        .toList();

    await prefs.setStringList(_customFiltersKey, jsonList);
  }

  @override
  Future<List<ColorFilterPreset>> getSavedCustomFilters() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonList = prefs.getStringList(_customFiltersKey) ?? [];

    return jsonList.map((jsonString) {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      return ColorFilterPreset(
        id: data['id'],
        name: data['name'],
        matrix: List<double>.from(data['matrix']),
      );
    }).toList();
  }
}
