import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/core/constants/constants.dart';
import 'package:boilerplate_flutter/features/filters/domain/entities/color_filter_preset.dart';
import 'package:boilerplate_flutter/features/filters/domain/usecases/get_filter_presets.dart';
import 'package:boilerplate_flutter/features/filters/domain/usecases/save_custom_filter.dart';
import 'package:meta/meta.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final GetFilterPresets getFilterPresets;
  final SaveCustomFilter saveCustomFilter;

  FilterBloc({required this.getFilterPresets, required this.saveCustomFilter})
      : super(FilterInitial()) {
    on<FilterLoad>(_onLoad);
    on<FilterSelect>(_onSelect);
    on<FilterSetIntensity>(_onSetIntensity);
    on<FilterAddCustom>(_onAddCustom);
    on<FilterToggle>(_onToggle);
  }

  Future<void> _onLoad(FilterLoad event, Emitter<FilterState> emit) async {
    emit(FilterLoading([]));
    try {
      final filters = await getFilterPresets();
      emit(FilterLoaded(filters, 0, 1.0, FilterDefaultMatrix.defaultMatrix));
    } catch (e) {
      emit(FilterError(e.toString()));
    }
  }

  void _onSelect(FilterSelect event, Emitter<FilterState> emit) {
    emit(state.copyWith(selectedFilterIndex: event.index));
  }

  void _onSetIntensity(FilterSetIntensity event, Emitter<FilterState> emit) {
    emit(state.copyWith(filterIntensity: event.intensity));
  }

  Future<void> _onAddCustom(
      FilterAddCustom event, Emitter<FilterState> emit) async {
    await saveCustomFilter(event.filter);
    add(FilterLoad());
  }

  void _onToggle(FilterToggle event, Emitter<FilterState> emit) {
    emit(state.copyWith(isFilterActive: !state.isFilterActive));
  }

  List<double> getAdjustedMatrix(double intensity) {
    final currentFilter = state.filters[state.selectedFilterIndex];
    final filterMatrix = currentFilter.matrix;

    final identityMatrix = FilterDefaultMatrix.defaultMatrix;

    // Interpolate between identity and filter matrix based on intensity
    List<double> result = [];
    for (int i = 0; i < 20; i++) {
      result.add(
          identityMatrix[i] * (1 - intensity) + filterMatrix[i] * intensity);
    }
    return result;
  }
}
