import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../pages/login_page.dart';
import '../services/metamask_service.dart';

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
