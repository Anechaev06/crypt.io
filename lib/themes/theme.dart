import 'package:crypt_io/constants/colors.dart';
import 'package:crypt_io/themes/text_theme.dart';
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
