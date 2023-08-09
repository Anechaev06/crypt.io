import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maskify/features/login/presentation/pages/login_page.dart';
import 'package:maskify/features/metamask/data/repositories/metamask_service.dart';
import 'package:maskify/features/swap/data/repositories/swap_service.dart';
import 'package:maskify/features/coin/data/repositories/coin_service.dart';
import 'package:maskify/app/themes/theme.dart';
import 'package:maskify/app/presentation/pages/app_page.dart';

class App extends StatelessWidget {
  final bool isLoggedIn;

  App({super.key, required this.isLoggedIn}) {
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
      home: isLoggedIn ? const AppPage() : LoginPage(),
    );
  }
}
