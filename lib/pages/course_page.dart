import 'package:flutter/material.dart';
import 'package:crypt_io/widgets/categories_widget.dart';
import 'package:crypt_io/widgets/coin_widget.dart';
import 'package:crypt_io/widgets/market_changes_widget.dart';
import 'package:get/get.dart';
import '../services/coin_service.dart';

class CoursePage extends StatelessWidget {
  final CoinService controller = Get.find<CoinService>();

  CoursePage({super.key});

  Future<void> refreshData() => controller.fetchCoins();

  @override
  Widget build(BuildContext context) {
    double padding = MediaQuery.of(context).size.width * 0.05;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: RefreshIndicator(
        onRefresh: refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MarketChanges(controller: controller),
              SizedBox(height: padding),
              CategoriesWidget(controller: controller),
              _buildCoinList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoinList() {
    return GetBuilder<CoinService>(
      builder: (controller) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.coinsList.length,
          itemBuilder: (context, index) => Column(
            children: [
              CoinWidget(
                index: index,
                controller: controller,
              ),
              if (index != controller.coinsList.length - 1)
                const Divider(
                  height: 10,
                  thickness: 0.25,
                  color: Colors.grey,
                ),
            ],
          ),
        );
      },
    );
  }
}
