import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/metamask_service.dart';
import '../widgets/navigation_widget.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _addressController = TextEditingController();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _buildBody(context),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildAddressTextField(),
        ElevatedButton(
          onPressed: () => _connectButtonPressed(context),
          child: const Text('Connect'),
        ),
      ],
    );
  }

  TextField _buildAddressTextField() {
    return TextField(
      controller: _addressController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        labelText: 'Enter your private key',
        labelStyle:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600]!),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.orange),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey[400]!),
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorStyle: const TextStyle(color: Colors.red),
      ),
    );
  }

  Future<void> _connectButtonPressed(BuildContext context) async {
    final privateKey = _addressController.text;
    final MetamaskService metamaskService = Get.find();

    try {
      metamaskService.loginWithPrivateKey(privateKey);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);
      _navigateToHome(context);
    } catch (e) {
      _showErrorDialog(context, e.toString());
    }
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const NavigationWidget(),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text('Failed to connect: $message'),
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
