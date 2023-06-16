import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maskify/pages/login_page.dart';
import 'package:maskify/services/auth_service.dart';
import 'package:maskify/services/coin_service.dart';
import 'package:maskify/services/metamask_service.dart';
import 'package:maskify/services/swap_service.dart';
import 'package:maskify/themes/theme.dart';
import 'package:maskify/widgets/navigation_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final isLoggedIn = await AuthService.isLoggedIn();
  runApp(MyApp(isLoggedIn: isLoggedIn));
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
