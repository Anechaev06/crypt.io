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
        final favoriteCoins = controller.favorites;
        return Column(
          children: [
            if (favoriteCoins.isNotEmpty)
              const Text(
                "Favorites",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: favoriteCoins.length,
              separatorBuilder: (context, index) => const Divider(
                height: 25,
                thickness: 0.25,
                color: Colors.grey,
              ),
              itemBuilder: (context, index) {
                return CoinWidget(
                  index: favoriteCoins[index],
                  controller: controller,
                );
              },
            ),
          ],
        );
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
        final isFavorite = controller.favorites.contains(index);
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
          onPressed: () => controller.addFavorite(index),
        );
      },
    );
  }
}
