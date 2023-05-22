import 'package:flutter/material.dart';
import 'package:crypt_io/widgets/navigation_widget.dart';
import 'package:crypt_io/controllers/metamask_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _addressController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your Ethereum address',
              ),
            ),
            ElevatedButton(
              onPressed: () => _connectButtonPressed(context),
              child: const Text('Connect'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _connectButtonPressed(BuildContext context) async {
    final userAddress = _addressController.text;
    final MetamaskController metamaskController = Get.find();

    try {
      await metamaskController.getBalance(userAddress);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('isLoggedIn', true);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const NavigationWidget(),
        ),
      );
    } catch (e) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text('Failed to connect: $e'),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
