import 'package:maskify/constants/colors.dart';
import 'package:maskify/themes/text_theme.dart';
import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: bgColor,
    textTheme: AppTextTheme.darkTextTheme,
    primarySwatch: Colors.orange,
  );
}
