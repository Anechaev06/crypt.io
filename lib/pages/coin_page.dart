import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/coin_service.dart';
import '../widgets/coin_chart_widget.dart';
import '../widgets/favorite_widget.dart';

class CoinPage extends StatelessWidget {
  final int index;

  const CoinPage({super.key, required this.index});
  @override
  Widget build(BuildContext context) {
    final coinService = Get.find<CoinService>();
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          actions: [FavoriteCoinButton(index: index)],
          title: Text(coinService.coinsList[index].symbol.toUpperCase()),
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
                          "${coinService.coinsList[index].symbol.toUpperCase()}1 = ",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          '\$${coinService.coinsList[index].currentPrice.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${coinService.coinsList[index].priceChangePercentage24H.toStringAsFixed(2)}%',
                      // style: TextStyle(color: priceChangeColor),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 125),

              // Coin Chart
              CoinChart(service: coinService, index: index),
            ],
          );
        }),
      ),
    );
  }
}
