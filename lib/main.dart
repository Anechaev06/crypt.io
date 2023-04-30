import 'package:crypt_io/pages/login_page.dart';
import 'package:crypt_io/themes/theme.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Crypt.io",
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
