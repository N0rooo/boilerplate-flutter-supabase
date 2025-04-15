import 'package:boilerplate_flutter/core/theme/domain/entity/theme_entity.dart';

abstract class ThemeRepository {
  Future<ThemeEntity> getTheme();
  Future saveTheme(ThemeEntity theme);
}
