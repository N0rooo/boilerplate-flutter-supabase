part of 'filter_bloc.dart';

@immutable
sealed class FilterEvent {}

class FilterLoad extends FilterEvent {}

class FilterSelect extends FilterEvent {
  final int index;
  FilterSelect(this.index);
}

class FilterSetIntensity extends FilterEvent {
  final double intensity;

  FilterSetIntensity(this.intensity);
}

class FilterToggle extends FilterEvent {}

class FilterAddCustom extends FilterEvent {
  final ColorFilterPreset filter;

  FilterAddCustom(this.filter);
}
