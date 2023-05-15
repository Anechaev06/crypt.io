import 'package:crypt_io/controllers/coin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MarketChanges extends StatelessWidget {
  final CoinController controller;

  const MarketChanges({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        final coinsList = controller.coinsList;
        final btcPriceChange =
            coinsList.isNotEmpty ? coinsList[0].priceChangePercentage24H : 0.0;
        final ethPriceChange =
            coinsList.isNotEmpty ? coinsList[1].priceChangePercentage24H : 0.0;
        final marketChanges = (btcPriceChange + ethPriceChange) / 2;

        final marketChangesText = marketChanges > 0
            ? 'Market is up'
            : marketChanges < 0
                ? 'Market is down'
                : 'Market is stable';

        final marketChangesIcon = marketChanges > 0
            ? Icons.arrow_drop_up
            : marketChanges < 0
                ? Icons.arrow_drop_down
                : null;

        final marketChangesColor = marketChanges > 0
            ? Colors.green
            : marketChanges < 0
                ? Colors.red
                : Colors.grey;

        return Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "In the past 24 hours",
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    marketChangesText,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Row(
                    children: [
                      Icon(
                        marketChangesIcon,
                        color: marketChangesColor,
                      ),
                      Text(
                        '${marketChanges.toStringAsFixed(2)}%',
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium
                            ?.copyWith(color: marketChangesColor),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
