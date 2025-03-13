import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/core/constants/constants.dart';
import 'package:boilerplate_flutter/features/filters/domain/entities/color_filter_preset.dart';
import 'package:boilerplate_flutter/features/filters/domain/usecases/delete_custom_filter.dart';
import 'package:boilerplate_flutter/features/filters/domain/usecases/get_filter_presets.dart';
import 'package:boilerplate_flutter/features/filters/domain/usecases/save_custom_filter.dart';
import 'package:boilerplate_flutter/features/filters/domain/usecases/update_custom_filter.dart';
import 'package:meta/meta.dart';

part 'filter_event.dart';
part 'filter_state.dart';

class FilterBloc extends Bloc<FilterEvent, FilterState> {
  final GetFilterPresets getFilterPresets;
  final SaveCustomFilter saveCustomFilter;
  final DeleteCustomFilter deleteCustomFilter;
  final UpdateCustomFilter updateCustomFilter;

  FilterBloc(
      {required this.getFilterPresets,
      required this.saveCustomFilter,
      required this.deleteCustomFilter,
      required this.updateCustomFilter})
      : super(FilterInitial()) {
    on<FilterLoad>(_onLoad);
    on<FilterSelect>(_onSelect);
    on<FilterSetIntensity>(_onSetIntensity);
    on<FilterAddCustom>(_onAddCustom);
    on<FilterToggle>(_onToggle);
    on<FilterDelete>(_onDelete);
    on<FilterUpdate>(_onUpdate);
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

    const identityMatrix = FilterDefaultMatrix.defaultMatrix;

    List<double> result = [];
    for (int i = 0; i < 20; i++) {
      result.add(
          identityMatrix[i] * (1 - intensity) + filterMatrix[i] * intensity);
    }
    return result;
  }

  void _onDelete(FilterDelete event, Emitter<FilterState> emit) async {
    await deleteCustomFilter(event.filter);
    add(FilterLoad());
  }

  void _onUpdate(FilterUpdate event, Emitter<FilterState> emit) async {
    await updateCustomFilter(event.filter);
    add(FilterLoad());
  }
}
