import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maskify/src/features/auth/repositories/metamask_repository.dart';
import 'package:maskify/src/features/coin_swap/data/repositories/swap_repository.dart';
import 'package:maskify/src/features/coin_tracking/data/repositories/coin_repository.dart';
import 'package:maskify/src/core/themes/theme.dart';
import 'package:maskify/src/features/home/presentation/pages/home_page.dart';

import 'features/auth/presentation/pages/login_page.dart';

class App extends StatelessWidget {
  final bool isLoggedIn;

  App({super.key, required this.isLoggedIn}) {
    _initServices();
  }

  void _initServices() {
    Get.lazyPut(() => MetamaskRepository());
    Get.lazyPut(() => SwapRepository());
    Get.lazyPut(() => CoinRepository());
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
