import 'package:crypt_io/widgets/crypto_list_widget.dart';
import 'package:crypt_io/widgets/market_changes_widget.dart';
import 'package:flutter/material.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "In the past 24 hours",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 5),
              const MarketChanges(),
              const SizedBox(height: 20),
              const CryptoListWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
