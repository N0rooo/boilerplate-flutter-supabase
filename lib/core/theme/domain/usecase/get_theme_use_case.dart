import 'package:boilerplate_flutter/core/theme/domain/entity/theme_entity.dart';
import 'package:boilerplate_flutter/core/theme/domain/repository/theme_repository.dart';

class GetThemeUseCase {
  final ThemeRepository themeRepository;

  GetThemeUseCase({required this.themeRepository});

  Future<ThemeEntity> call() async {
    return await themeRepository.getTheme();
  }
}
