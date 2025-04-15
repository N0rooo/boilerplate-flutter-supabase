part of 'theme_bloc.dart';

@immutable
sealed class ThemeEvent {}

final class GetThemeEvent extends ThemeEvent {}

final class ToggleThemeEvent extends ThemeEvent {}
