import 'package:flutter/material.dart';
import '../../data/repositories/coin_service.dart';
import '../pages/coin_page.dart';

class CoinWidget extends StatelessWidget {
  final int index;
  final CoinService service;

  const CoinWidget({
    super.key,
    required this.service,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    final coin = service.coinsList[index];
    final coinPrice = coin.currentPrice;
    final coinPriceChange = coin.priceChangePercentage24H;
    final coinPriceChangeColor = coinPriceChange > 0
        ? Colors.green
        : coinPriceChange < 0
            ? Colors.red
            : Colors.grey;

    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CoinPage(index: index),
          ),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.all(5),
        elevation: 0,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                // Coin Image
                SizedBox(
                  height: 35,
                  child: Image.network(coin.image),
                ),
                const SizedBox(width: 10),
                // Coin Symbol
                Text(
                  service.coinsList[index].symbol.toUpperCase(),
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontSize: 18),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Coin Price
                Text(
                  '\$${coinPrice.toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 10),
                // Coin Price Change 24h
                Text(
                  '${coinPriceChange.toStringAsFixed(1)}%',
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: coinPriceChangeColor),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
