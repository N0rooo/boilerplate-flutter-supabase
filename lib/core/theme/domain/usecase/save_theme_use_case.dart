import 'package:boilerplate_flutter/core/theme/domain/entity/theme_entity.dart';
import 'package:boilerplate_flutter/core/theme/domain/repository/theme_repository.dart';

class SaveThemeUseCase {
  final ThemeRepository themeRepository;

  SaveThemeUseCase({required this.themeRepository});

  Future<void> call(ThemeEntity theme) async {
    await themeRepository.saveTheme(theme);
  }
}
