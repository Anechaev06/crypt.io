import 'package:maskify/constants/colors.dart';
import 'package:maskify/widgets/coin_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/coin_service.dart';

class FavoriteCoinListWidget extends StatelessWidget {
  const FavoriteCoinListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CoinService>(
      builder: (service) {
        final favoriteCoinIds = service.favorites;
        if (favoriteCoinIds.isEmpty) {
          return const SizedBox.shrink();
        } else {
          final favoriteCoinsIndices = service.coinsList
              .asMap()
              .entries
              .where((entry) => favoriteCoinIds.contains(entry.value.id))
              .map((entry) => entry.key)
              .toList();

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              height: MediaQuery.of(context).size.height * 0.5,
              child: ListView.separated(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemCount: favoriteCoinsIndices.length,
                separatorBuilder: (context, index) => const Divider(
                  height: 5,
                  thickness: 0.25,
                  color: Colors.grey,
                ),
                itemBuilder: (context, index) => CoinWidget(
                  index: favoriteCoinsIndices[index],
                  service: service,
                ),
              ),
            ),
          );
        }
      },
    );
  }
}

class FavoriteCoinButton extends StatelessWidget {
  final int index;
  const FavoriteCoinButton({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CoinService>(
      builder: (service) {
        final String coinId = service.coinsList[index].id;
        final isFavorite = service.favorites.contains(coinId);
        return IconButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            elevation: 0,
            foregroundColor: whiteColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
              side: const BorderSide(color: whiteColor),
            ),
          ),
          icon: isFavorite
              ? const Icon(Icons.favorite_rounded)
              : const Icon(Icons.favorite_outline_rounded),
          onPressed: () => service.addFavorite(coinId),
        );
      },
    );
  }
}
