import 'package:flutter/material.dart';
import 'src/app.dart';
import 'src/features/auth/repositories/login_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isLoggedIn = await LoginRepository.isLoggedIn();
  runApp(App(isLoggedIn: isLoggedIn));
}
