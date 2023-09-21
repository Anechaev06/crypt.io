import 'package:flutter/material.dart';
import 'package:maskify/src/features/home/presentation/widgets/categories_widget.dart';
import 'package:maskify/src/features/coin_tracking/presentation/widgets/coin_widget.dart';
import 'package:maskify/src/features/home/presentation/widgets/market_changes_widget.dart';
import 'package:get/get.dart';
import '../../../coin_tracking/data/repositories/coin_repository.dart';

class MarketPage extends StatelessWidget {
  const MarketPage({super.key});

  @override
  Widget build(BuildContext context) {
    final coinRepository = Get.find<CoinRepository>();
    Future refreshData() => coinRepository.fetchCoins();

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
    return GetBuilder<CoinRepository>(
      builder: (service) {
        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: service.coinsList.length,
          itemBuilder: (context, index) => Column(
            children: [
              CoinWidget(
                index: index,
                coinRepository: service,
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
