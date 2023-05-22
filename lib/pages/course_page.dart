import 'package:flutter/material.dart';
import 'package:crypt_io/widgets/categories_widget.dart';
import 'package:crypt_io/widgets/coin_widget.dart';
import 'package:crypt_io/widgets/market_changes_widget.dart';
import 'package:get/get.dart';
import '../controllers/coin_controller.dart';

class CoursePage extends StatelessWidget {
  CoursePage({super.key});
  final CoinController controller = Get.put(CoinController());
  Future<void> _refreshData() async => await controller.fetchCoins();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(25),
      child: RefreshIndicator(
        onRefresh: _refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              MarketChanges(controller: controller),
              const SizedBox(height: 25),
              CategoriesWidget(controller: controller),
              _buildCoinList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoinList() {
    return GetBuilder<CoinController>(
      builder: (controller) {
        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.coinsList.length,
          separatorBuilder: (context, index) => const Divider(
            height: 10,
            thickness: 0.25,
            color: Colors.grey,
          ),
          itemBuilder: (context, index) => CoinWidget(
            index: index,
            controller: controller,
          ),
        );
      },
    );
  }
}
