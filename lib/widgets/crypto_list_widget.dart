import 'package:crypt_io/constants/colors.dart';
import 'package:crypt_io/widgets/crypto_widget.dart';
import 'package:flutter/material.dart';

class CryptoListWidget extends StatelessWidget {
  const CryptoListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const CategoriesWidget(),
          Expanded(
            child: ListView(
              children: [
                buildDivider(),
                const CryptoWidget(symbol: "BTC"),
                buildDivider(),
                const CryptoWidget(symbol: "ETH"),
                buildDivider(),
                const CryptoWidget(symbol: "Doge"),
                buildDivider(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            child: Text(
              "All coins",
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: bgColor,
                  ),
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            child: Text(
              "Top gainers",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            child: Text(
              "Top losers",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildDivider() {
  return const Divider(
    height: 25,
    thickness: 0.25,
    color: Colors.grey,
  );
}
