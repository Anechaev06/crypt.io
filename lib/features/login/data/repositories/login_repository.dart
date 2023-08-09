import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../metamask/data/repositories/metamask_service.dart';

class LoginRepository {
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final isFirstLogin = prefs.getBool('isFirstLogin') ?? true;

    if (!isLoggedIn) return false;
    if (isFirstLogin) {
      await prefs.setBool('isFirstLogin', false);
      return true;
    } else {
      return _authenticateUser();
    }
  }

  static Future<bool> _authenticateUser() async {
    final localAuth = LocalAuthentication();
    return localAuth.authenticate(
      localizedReason: 'Please authenticate to open the app',
    );
  }

  static Future<void> loginUser(String privateKey) async {
    final MetamaskService metamaskService = Get.find();
    await metamaskService.loginWithPrivateKey(privateKey);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
  }
}
