import 'package:boilerplate_flutter/core/theme/domain/entity/theme_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeLocalDatasource {
  final SharedPreferences sharedPreferences;

  ThemeLocalDatasource({required this.sharedPreferences});

  Future<ThemeEntity> getTheme() async {
    var themeValue = sharedPreferences.getString('theme_type');
    if (themeValue == 'light') {
      return ThemeEntity(themeType: ThemeType.light);
    }
    return ThemeEntity(themeType: ThemeType.dark);
  }

  Future saveTheme(ThemeEntity theme) async {
    var themeValue = theme.themeType == ThemeType.light ? 'light' : 'dark';
    await sharedPreferences.setString('theme_type', themeValue);
  }
}
