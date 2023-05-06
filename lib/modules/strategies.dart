import 'package:flutter/material.dart';

class StrategiesPage extends StatelessWidget {
  const StrategiesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text("Strategies"),
      ),
    );
  }
}
