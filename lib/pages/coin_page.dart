import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/coin_controller.dart';

class CoinPage extends StatelessWidget {
  final int index;
  final CoinController controller;

  const CoinPage({super.key, required this.controller, required this.index});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(controller.coinsList[index].symbol.toUpperCase()),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Obx(() {
          return Column(
            children: [
              // Price and price change
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          "${controller.coinsList[index].symbol.toUpperCase()}1 = ",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          '\$${controller.coinsList[index].currentPrice.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${controller.coinsList[index].priceChangePercentage24H.toStringAsFixed(2)}%',
                      // style: TextStyle(color: priceChangeColor),
                    ),
                  ],
                ),
              ),
              // Graph

              const SizedBox(height: 600),
              // Buy sell
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      minimumSize: const Size(180, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text("Buy"),
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[500],
                      minimumSize: const Size(180, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text("Sell"),
                  ),
                ],
              )
            ],
          );
        }),
      ),
    );
  }
}
