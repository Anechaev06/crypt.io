import 'package:crypt_io/constants/colors.dart';
import 'package:crypt_io/widgets/coin_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/coin_controller.dart';

class FavoriteCoinWidget extends StatelessWidget {
  const FavoriteCoinWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CoinController>(
      builder: (controller) {
        final favoriteCoinIds = controller.favorites;
        if (favoriteCoinIds.isEmpty) {
          return const SizedBox.shrink();
        } else {
          final favoriteCoinsIndices = controller.coinsList
              .asMap()
              .entries
              .where((entry) => favoriteCoinIds.contains(entry.value.id))
              .map((entry) => entry.key)
              .toList();

          return ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 237),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: favoriteCoinsIndices.length,
              separatorBuilder: (context, index) => const Divider(
                height: 5,
                thickness: 0.25,
                color: Colors.grey,
              ),
              itemBuilder: (context, index) => CoinWidget(
                index: favoriteCoinsIndices[index],
                controller: controller,
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
    return GetBuilder<CoinController>(
      builder: (controller) {
        final String coinId = controller.coinsList[index].id;
        final isFavorite = controller.favorites.contains(coinId);
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
          onPressed: () => controller.addFavorite(coinId),
        );
      },
    );
  }
}
