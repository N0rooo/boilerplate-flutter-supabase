part of 'filter_bloc.dart';

@immutable
class FilterState {
  final List<ColorFilterPreset> filters;
  final int selectedFilterIndex;
  final double filterIntensity;
  final List<double> adjustedMatrix;
  final bool isLoading;
  final bool isFilterActive;

  const FilterState({
    required this.filters,
    required this.selectedFilterIndex,
    required this.filterIntensity,
    required this.adjustedMatrix,
    required this.isLoading,
    required this.isFilterActive,
  });

  ColorFilterPreset get selectedFilter => selectedFilterIndex < filters.length
      ? filters[selectedFilterIndex]
      : filters.first;

  FilterState copyWith({
    List<ColorFilterPreset>? filters,
    int? selectedFilterIndex,
    double? filterIntensity,
    List<double>? adjustedMatrix,
    bool? isLoading,
    bool? isFilterActive,
  }) {
    return FilterState(
      filters: filters ?? this.filters,
      selectedFilterIndex: selectedFilterIndex ?? this.selectedFilterIndex,
      filterIntensity: filterIntensity ?? this.filterIntensity,
      adjustedMatrix: adjustedMatrix ?? this.adjustedMatrix,
      isLoading: isLoading ?? this.isLoading,
      isFilterActive: isFilterActive ?? this.isFilterActive,
    );
  }
}

class FilterInitial extends FilterState {
  FilterInitial()
      : super(
          filters: [],
          selectedFilterIndex: 0,
          filterIntensity: 1.0,
          adjustedMatrix: [],
          isLoading: true,
          isFilterActive: false,
        );
}

class FilterLoading extends FilterState {
  FilterLoading(List<ColorFilterPreset> filters)
      : super(
          filters: filters,
          selectedFilterIndex: 0,
          filterIntensity: 1.0,
          adjustedMatrix: [],
          isLoading: true,
          isFilterActive: false,
        );
}

class FilterLoaded extends FilterState {
  FilterLoaded(List<ColorFilterPreset> filters, int selectedIndex,
      double intensity, List<double> matrix)
      : super(
          filters: filters,
          selectedFilterIndex: selectedIndex,
          filterIntensity: intensity,
          adjustedMatrix: matrix,
          isLoading: false,
          isFilterActive: false,
        );
}

class FilterError extends FilterState {
  final String message;

  FilterError(this.message)
      : super(
          filters: [],
          selectedFilterIndex: 0,
          filterIntensity: 1.0,
          adjustedMatrix: [],
          isLoading: false,
          isFilterActive: false,
        );
}
