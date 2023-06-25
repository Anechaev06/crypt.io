import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:maskify/constants/colors.dart';
import 'package:maskify/pages/login_page.dart';
import 'package:maskify/pages/send_page.dart';
import 'package:maskify/pages/swap_page.dart';
import 'package:maskify/services/metamask_service.dart';
import 'package:maskify/widgets/favorite_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final metamaskService = Get.find<MetamaskService>();

    return SlidingUpPanel(
      panel: SettingsSection(metamaskService: metamaskService),
      color: bgColor,
      minHeight: 60,
      maxHeight: MediaQuery.of(context).size.height / 2,
      backdropEnabled: true,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      body: RefreshIndicator(
        onRefresh: () async {
          await metamaskService
              .updateBalanceFromBlockchain(metamaskService.userAddress.value);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(25),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ProfileSection(metamaskService: metamaskService),
                  const SizedBox(
                    height: 400,
                    child: FavoriteCoinWidget(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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

class SettingsSection extends StatelessWidget {
  final MetamaskService metamaskService;

  const SettingsSection({super.key, required this.metamaskService});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, right: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const DragHandle(),
          const SizedBox(height: 15),
          const Text(
            "Settings",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          HideBalanceWidget(metamaskService: metamaskService),
          const Divider(height: 5, thickness: 0.25, color: Colors.grey),
          NetworkWidget(metamaskService: metamaskService),
          const Divider(height: 5, thickness: 0.25, color: Colors.grey),
          PushNotificationsWidget(metamaskService: metamaskService),
          LogoutButton(metamaskService: metamaskService),
        ],
      ),
    );
  }
}

class DragHandle extends StatelessWidget {
  const DragHandle({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 5,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }
}

class HideBalanceWidget extends StatelessWidget {
  final MetamaskService metamaskService;

  const HideBalanceWidget({super.key, required this.metamaskService});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Hide Balance", style: TextStyle(fontSize: 20)),
            Switch(
              value: metamaskService.hideBalance.value,
              onChanged: (value) {
                metamaskService.hideBalance.value = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NetworkWidget extends StatelessWidget {
  final MetamaskService metamaskService;

  const NetworkWidget({super.key, required this.metamaskService});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            "Network",
            style: TextStyle(fontSize: 20),
          ),
          Obx(
            () => DropdownButton<String>(
              value: metamaskService.activeNetwork.value,
              items: <String>['eth', 'bsc'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.toUpperCase()),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  metamaskService.switchNetwork(newValue);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class PushNotificationsWidget extends StatelessWidget {
  final MetamaskService metamaskService;

  const PushNotificationsWidget({super.key, required this.metamaskService});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Push Notifications", style: TextStyle(fontSize: 20)),
            Switch(
                value: metamaskService.isNotificationEnabled.value,
                onChanged: (value) =>
                    metamaskService.isNotificationEnabled.value = value),
          ],
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  final MetamaskService metamaskService;

  const LogoutButton({super.key, required this.metamaskService});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: OutlinedButton(
        onPressed: () async {
          metamaskService.logout();

          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool('isLoggedIn', false);

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => LoginPage(),
            ),
          );
        },
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
          ),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.red),
        ),
        child: const Text("LogOut"),
      ),
    );
  }
}
