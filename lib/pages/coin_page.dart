import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/coin_controller.dart';
import '../widgets/favorite_widget.dart';

class CoinPage extends StatelessWidget {
  final int index;
  final CoinController controller;

  const CoinPage({super.key, required this.controller, required this.index});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          actions: [FavoriteCoinButton(index: index)],
          title: Text(controller.coinsList[index].symbol.toUpperCase()),
        ),
        body: Obx(() {
          return Column(
            children: [
              // Price and price change
              Padding(
                padding: const EdgeInsets.all(15),
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
              // Chart

              const SizedBox(height: 600),
              Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    // Chat gpt swap button here !!!
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        // backgroundColor: Colors.blueGrey,
                        minimumSize: const Size(100, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      child: const Text("Swap"),
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            minimumSize: const Size(125, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Text("Buy"),
                        ),
                        const SizedBox(width: 10),
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red[500],
                            minimumSize: const Size(125, 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                          ),
                          child: const Text("Sell"),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        }),
      ),
    );
  }
}
