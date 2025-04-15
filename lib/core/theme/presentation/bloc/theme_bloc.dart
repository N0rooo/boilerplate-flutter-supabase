import 'package:bloc/bloc.dart';
import 'package:boilerplate_flutter/core/theme/domain/entity/theme_entity.dart';
import 'package:boilerplate_flutter/core/theme/domain/usecase/get_theme_use_case.dart';
import 'package:boilerplate_flutter/core/theme/domain/usecase/save_theme_use_case.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

part 'theme_event.dart';
part 'theme_state.dart';

class ThemeBloc extends Bloc<ThemeEvent, ThemeState> {
  final GetThemeUseCase getThemeUseCase;
  final SaveThemeUseCase saveThemeUseCase;

  ThemeBloc({
    required this.getThemeUseCase,
    required this.saveThemeUseCase,
  }) : super(ThemeInitial()) {
    on<GetThemeEvent>(_onGetThemeEvent);
    on<ToggleThemeEvent>(_onToggleThemeEvent);
  }

  Future<void> _onGetThemeEvent(
      GetThemeEvent event, Emitter<ThemeState> emit) async {
    try {
      final theme = await getThemeUseCase();
      emit(ThemeSuccess(themeType: theme.themeType));
    } catch (e) {
      emit(ThemeError(message: e.toString()));
    }
  }

  Future<void> _onToggleThemeEvent(
      ToggleThemeEvent event, Emitter<ThemeState> emit) async {
    try {
      if (state is ThemeSuccess) {
        final currentState = state as ThemeSuccess;
        final newThemeType = currentState.themeType == ThemeType.light
            ? ThemeType.dark
            : ThemeType.light;

        await saveThemeUseCase(ThemeEntity(themeType: newThemeType));
        emit(ThemeSuccess(themeType: newThemeType));
      }
    } catch (e) {
      emit(ThemeError(message: e.toString()));
    }
  }
}
