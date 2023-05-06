import 'package:flutter/material.dart';
import '../controllers/coin_controller.dart';
import '../pages/coin_page.dart';
import 'package:get/get.dart';

class CoinWidget extends StatelessWidget {
  final int index;
  final CoinController controller;

  const CoinWidget({
    super.key,
    required this.controller,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoinPage(
              index: index,
              controller: controller,
            ),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.all(5),
        elevation: 0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Coin Image
                SizedBox(
                  height: 40,
                  child: Image.network(
                    controller.coinsList[index].image,
                  ),
                ),
                const SizedBox(width: 10),
                // Coin Symbol
                Text(
                  controller.coinsList[index].symbol.toUpperCase(),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(width: 70),
                // Coin Price Change 24H
                Obx(() {
                  return Text(
                    '${controller.coinsList[index].priceChangePercentage24H.toStringAsFixed(1)}%',
                    style: Theme.of(context).textTheme.bodyMedium,
                  );
                }),
              ],
            ),
            // Coin Price
            Obx(() {
              return Text(
                '\$${controller.coinsList[index].currentPrice.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyMedium,
              );
            }),
          ],
        ),
      ),
    );
  }
}
