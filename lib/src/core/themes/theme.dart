import 'package:maskify/src/core/constants/colors.dart';
import 'package:maskify/src/core/themes/text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgColor,
    textTheme: AppTextTheme.darkTextTheme,
    primarySwatch: Colors.orange,
  );
}
