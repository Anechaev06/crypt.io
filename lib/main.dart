import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:crypt_io/services/coin_service.dart';
import 'package:crypt_io/services/metamask_service.dart';
import 'package:crypt_io/services/swap_service.dart';
import 'package:crypt_io/widgets/navigation_widget.dart';
import 'package:crypt_io/pages/login_page.dart';
import 'package:crypt_io/themes/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isLoggedIn = await _isLoggedIn();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

Future<bool> _isLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  MyApp({super.key, required this.isLoggedIn}) {
    _initServices();
  }

  void _initServices() {
    Get.lazyPut(() => MetamaskService());
    Get.lazyPut(() => SwapService());
    Get.lazyPut(() => CoinService());
  }

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
