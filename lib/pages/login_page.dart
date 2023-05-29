import 'package:flutter/material.dart';
import 'package:crypt_io/widgets/navigation_widget.dart';
import 'package:crypt_io/controllers/metamask_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _addressController = TextEditingController();

  LoginPage({super.key});

  final double _borderRadius = 10.0;
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
                labelText: 'Enter your Ethereum address',
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
