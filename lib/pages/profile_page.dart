import 'package:crypt_io/widgets/favorite_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../controllers/metamask_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final metamaskController = Get.find<MetamaskController>();

    return Padding(
      padding: const EdgeInsets.all(25),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      height: 125,
                      child: Image.asset("assets/images/wizzard.png")),
                  const Text(
                    "Anechaev",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Obx(
                    () {
                      final ethBalance = metamaskController.balance.value;
                      return Text(
                        ethBalance,
                        style: const TextStyle(fontSize: 24),
                      );
                    },
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(
                          text: metamaskController.userAddress.value));
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18.0),
                          side: const BorderSide(color: Colors.red),
                        ),
                      ),
                    ),
                    child: Obx(
                      () {
                        final userAddress =
                            metamaskController.userAddress.value;
                        return Text(
                          "${userAddress.substring(0, 6)}...${userAddress.substring(userAddress.length - 4)}",
                        );
                      },
                    ),
                  ),
                ],
              ),
              const FavoriteCoinWidget(),
              Text(
                "App Settings",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontSize: 22),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
