import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'controllers/metamask_controller.dart';
import 'pages/login_page.dart';
import 'themes/theme.dart';
import 'widgets/navigation_widget.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(isLoggedIn: isLoggedIn));
  Get.put(MetamaskController());
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crypt.io',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const NavigationWidget() : LoginPage(),
    );
  }
}
