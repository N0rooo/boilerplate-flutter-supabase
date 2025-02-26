import 'package:boilerplate_flutter/core/theme/app_palette.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTheme {
  static _border([Color color = AppPallete.borderColor]) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(
          color: color,
          width: 3,
        ),
      );

  static final darkThemeMode = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: AppPallete.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: AppPallete.backgroundColor,
    ),
    iconTheme: const IconThemeData(
      color: AppPallete.whiteColor,
    ),
    cupertinoOverrideTheme: const CupertinoThemeData(
      textTheme: CupertinoTextThemeData(
        actionTextStyle: TextStyle(
          color: AppPallete.whiteColor,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      contentPadding: const EdgeInsets.all(27),
      border: _border(),
      errorBorder: _border(AppPallete.errorColor),
      enabledBorder: _border(),
      focusedBorder: _border(AppPallete.gradient2),
    ),
  );
}
