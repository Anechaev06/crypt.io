import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maskify/pages/login_page.dart';
import 'package:maskify/services/coin_service.dart';
import 'package:maskify/services/metamask_service.dart';
import 'package:maskify/services/swap_service.dart';
import 'package:maskify/themes/theme.dart';
import 'package:maskify/widgets/navigation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isLoggedIn = await _isLoggedIn();
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

Future _isLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
  bool isFirstLogin = prefs.getBool('isFirstLogin') ?? true;

  if (isLoggedIn) {
    if (isFirstLogin) {
      await prefs.setBool('isFirstLogin', false);

      return true;
    } else {
      final localAuth = LocalAuthentication();
      bool didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Please authenticate to open the app',
      );
      return didAuthenticate;
    }
  } else {
    return false;
  }
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
    return GetMaterialApp(
      title: 'Crypt.io',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: isLoggedIn ? const NavigationWidget() : LoginPage(),
    );
  }
}
