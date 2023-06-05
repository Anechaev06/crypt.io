import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/coin_service.dart';
import '../widgets/favorite_widget.dart';

class CoinPage extends StatelessWidget {
  final int index;
  final CoinService service;

  const CoinPage({super.key, required this.service, required this.index});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          actions: [FavoriteCoinButton(index: index)],
          title: Text(service.coinsList[index].symbol.toUpperCase()),
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
                          "${service.coinsList[index].symbol.toUpperCase()}1 = ",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          '\$${service.coinsList[index].currentPrice.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${service.coinsList[index].priceChangePercentage24H.toStringAsFixed(2)}%',
                      // style: TextStyle(color: priceChangeColor),
                    ),
                  ],
                ),
              ),
              // Coin Chart
              CoinChart(service: service, index: index),
            ],
          );
        }),
      ),
    );
  }
}

class CoinChart extends StatelessWidget {
  final CoinService service;
  final int index;

  const CoinChart({super.key, required this.service, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
