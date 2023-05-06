import 'package:crypt_io/widgets/categories_widget.dart';
import 'package:crypt_io/widgets/coin_widget.dart';
import 'package:crypt_io/widgets/market_changes_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/coin_controller.dart';

class CoursePage extends StatelessWidget {
  CoursePage({super.key});

  final CoinController controller = Get.put(CoinController());

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(25),
          child: SingleChildScrollView(
            physics: const ScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "In the past 24 hours",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 5),
                MarketChanges(controller: controller),
                const CategoriesWidget(),
                Obx(() {
                  if (controller.isLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (controller.coinsList.isEmpty) {
                    return const Center(child: Text('No coins found.'));
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: controller.coinsList.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            CoinWidget(
                              index: index,
                              controller: controller,
                            ),
                            const Divider(
                              height: 25,
                              thickness: 0.25,
                              color: Colors.grey,
                            )
                          ],
                        );
                      },
                    );
                  }
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
