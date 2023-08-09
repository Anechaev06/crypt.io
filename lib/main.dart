import 'package:flutter/material.dart';
import 'package:maskify/features/login/data/repositories/login_repository.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isLoggedIn = await LoginRepository.isLoggedIn();
  runApp(App(isLoggedIn: isLoggedIn));
}
