import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/repositories/coin_repository.dart';
import '../widgets/coin_chart_widget.dart';
import '../widgets/favorite_coin_widget.dart';

class CoinPage extends StatelessWidget {
  final int index;

  const CoinPage({super.key, required this.index});
  @override
  Widget build(BuildContext context) {
    final coinRepository = Get.find<CoinRepository>();
    final coin = coinRepository.coinsList[index];
    final coinPrice = coin.currentPrice;
    final coinPriceChange = coin.priceChangePercentage24H;
    final coinPriceChangeColor = coinPriceChange > 0
        ? Colors.green
        : coinPriceChange < 0
            ? Colors.red
            : Colors.grey;

    final marketChangesIcon = coinPriceChange > 0
        ? Icons.arrow_drop_up
        : coinPriceChange < 0
            ? Icons.arrow_drop_down
            : null;

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          actions: [FavoriteCoinButton(index: index)],
          title: Text(coinRepository.coinsList[index].symbol.toUpperCase()),
        ),
        body: Obx(() {
          return Column(
            children: [
              // Price and price change
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "${coinRepository.coinsList[index].symbol.toUpperCase()}1 = ",
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        Text(
                          '\$${coinPrice.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(
                          marketChangesIcon,
                          color: coinPriceChangeColor,
                        ),
                        Text(
                          '${coinPriceChange.toStringAsFixed(2)}%',
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium
                              ?.copyWith(
                                  color: coinPriceChangeColor, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 50),

              // Coin Chart
              CoinChart(service: coinRepository, index: index),
            ],
          );
        }),
      ),
    );
  }
}
