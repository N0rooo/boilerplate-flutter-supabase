part of 'theme_bloc.dart';

enum ThemeStatus {
  initial,
  loading,
  success,
  error,
}

@immutable
sealed class ThemeState {}

final class ThemeInitial extends ThemeState {}

final class ThemeSuccess extends ThemeState {
  final ThemeType themeType;

  ThemeSuccess({required this.themeType});
}

final class ThemeError extends ThemeState {
  final String message;

  ThemeError({required this.message});
}
