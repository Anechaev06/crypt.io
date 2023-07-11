import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../pages/send_page.dart';
import '../pages/swap_page.dart';
import '../services/metamask_service.dart';

class ProfileSection extends StatelessWidget {
  final MetamaskService metamaskService;

  const ProfileSection({super.key, required this.metamaskService});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(height: 100, child: Image.asset("assets/metamask.png")),
        Obx(
          () {
            return Text(
              metamaskService.hideBalance.value
                  ? '***'
                  : '\$${metamaskService.balance.value}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            );
          },
        ),
        AddressButtonWidget(metamaskService: metamaskService),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Send Icon
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SendPage(),
                  ),
                );
              },
              icon: const Icon(Icons.send_rounded),
              label: const Text("Send"),
            ),
            const SizedBox(width: 10),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SwapPage(),
                  ),
                );
              },
              icon: const Icon(Icons.swap_horiz_rounded),
              label: const Text("Swap"),
            ),
          ],
        )
      ],
    );
  }
}

class AddressButtonWidget extends StatelessWidget {
  final MetamaskService metamaskService;

  const AddressButtonWidget({super.key, required this.metamaskService});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Clipboard.setData(
            ClipboardData(text: metamaskService.userAddress.value));
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      child: Obx(() {
        final userAddress = metamaskService.userAddress.value;
        return Text(
          userAddress.isEmpty
              ? ""
              : "${userAddress.substring(0, 6)}...${userAddress.substring(userAddress.length - 4)}",
        );
      }),
    );
  }
}
