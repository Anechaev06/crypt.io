import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/metamask_service.dart';
import '../widgets/navigation_widget.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _addressController = TextEditingController();
  final double _borderRadius = 10.0;

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
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(_borderRadius),
                ),
                labelText: 'Enter your private key',
                labelStyle: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.grey[600]!),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.orange),
                  borderRadius: BorderRadius.circular(_borderRadius),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey[400]!),
                  borderRadius: BorderRadius.circular(_borderRadius),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red),
                  borderRadius: BorderRadius.circular(_borderRadius),
                ),
                errorStyle: const TextStyle(color: Colors.red),
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
    final privateKey = _addressController.text;
    final metamaskService = Get.find<MetamaskService>();

    try {
      await metamaskService.loginWithPrivateKey(privateKey);

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
