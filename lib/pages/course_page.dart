import 'package:flutter/material.dart';
import 'package:crypt_io/widgets/categories_widget.dart';
import 'package:crypt_io/widgets/coin_widget.dart';
import 'package:crypt_io/widgets/market_changes_widget.dart';
import 'package:get/get.dart';
import '../services/coin_service.dart';

class CoursePage extends StatelessWidget {
  const CoursePage({super.key});

  @override
  Widget build(BuildContext context) {
    final coinService = Get.find<CoinService>();
    Future refreshData() => coinService.fetchCoins();

    return Padding(
      padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.05),
      child: RefreshIndicator(
        onRefresh: refreshData,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const MarketChanges(),
              const CategoriesWidget(),
              _buildCoinList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoinList() {
    return GetBuilder<CoinService>(
      builder: (service) {
        if (service.coinsList.isEmpty) {
          return const Center(child: Text('No coins found'));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: service.coinsList.length,
          itemBuilder: (context, index) => Column(
            children: [
              CoinWidget(
                index: index,
                service: service,
              ),
              if (index != service.coinsList.length - 1)
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
