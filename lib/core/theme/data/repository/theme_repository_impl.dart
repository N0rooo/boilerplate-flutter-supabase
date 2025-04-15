import 'package:boilerplate_flutter/core/theme/data/datasource/theme_local_datasource.dart';
import 'package:boilerplate_flutter/core/theme/domain/entity/theme_entity.dart';
import 'package:boilerplate_flutter/core/theme/domain/repository/theme_repository.dart';

class ThemeRepositoryImpl implements ThemeRepository {
  final ThemeLocalDatasource themeLocalDatasource;

  ThemeRepositoryImpl({required this.themeLocalDatasource});

  @override
  Future<ThemeEntity> getTheme() async {
    return await themeLocalDatasource.getTheme();
  }

  @override
  Future saveTheme(ThemeEntity theme) async {
    await themeLocalDatasource.saveTheme(theme);
  }
}
