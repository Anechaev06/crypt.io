import 'package:flutter/material.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../repositories/login_repository.dart';

class ConnectButton extends StatelessWidget {
  final TextEditingController controller;

  const ConnectButton({super.key, required this.controller});

  Future<void> _connectButtonPressed(BuildContext context) async {
    final privateKey = controller.text;
    await LoginRepository.loginUser(privateKey);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const AppPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _connectButtonPressed(context),
      child: const Text('Connect'),
    );
  }
}
