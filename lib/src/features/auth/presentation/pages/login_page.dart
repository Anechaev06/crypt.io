import 'package:flutter/material.dart';
import 'package:maskify/src/core/constants/colors.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../repositories/login_repository.dart';

class LoginPage extends StatelessWidget {
  final _addressController = TextEditingController();

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
        const SizedBox(height: 15),
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
          borderSide: const BorderSide(color: newPrimaryColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: newPrimaryColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorStyle: const TextStyle(color: Colors.red),
      ),
    );
  }

  Future<void> _connectButtonPressed(BuildContext context) async {
    final privateKey = _addressController.text;
    await LoginRepository.loginUser(privateKey);
    _navigateToHome(context);
  }

  void _navigateToHome(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const AppPage(),
      ),
    );
  }
}
