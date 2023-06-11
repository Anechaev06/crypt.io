import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:local_auth/local_auth.dart';
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

  MyApp({Key? key, required this.isLoggedIn}) : super(key: key) {
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
