import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../login/presentation/pages/login_page.dart';
import '../../../metamask/data/repositories/metamask_repository.dart';

class SettingsSection extends StatelessWidget {
  final MetamaskRepository metamaskRepository;

  const SettingsSection({super.key, required this.metamaskRepository});

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
          HideBalanceWidget(metamaskRepository: metamaskRepository),
          const Divider(height: 5, thickness: 0.25, color: Colors.grey),
          NetworkWidget(metamaskRepository: metamaskRepository),
          const Divider(height: 5, thickness: 0.25, color: Colors.grey),
          PushNotificationsWidget(metamaskRepository: metamaskRepository),
          LogoutButton(metamaskRepository: metamaskRepository),
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
  final MetamaskRepository metamaskRepository;

  const HideBalanceWidget({super.key, required this.metamaskRepository});

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
              value: metamaskRepository.hideBalance.value,
              onChanged: (value) {
                metamaskRepository.hideBalance.value = value;
              },
            ),
          ],
        ),
      ),
    );
  }
}

class NetworkWidget extends StatelessWidget {
  final MetamaskRepository metamaskRepository;

  const NetworkWidget({super.key, required this.metamaskRepository});

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
              value: metamaskRepository.activeNetwork.value,
              items: <String>['eth', 'bsc'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.toUpperCase()),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  metamaskRepository.switchNetwork(newValue);
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
  final MetamaskRepository metamaskRepository;

  const PushNotificationsWidget({super.key, required this.metamaskRepository});

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
                value: metamaskRepository.isNotificationEnabled.value,
                onChanged: (value) =>
                    metamaskRepository.isNotificationEnabled.value = value),
          ],
        ),
      ),
    );
  }
}

class LogoutButton extends StatelessWidget {
  final MetamaskRepository metamaskRepository;

  const LogoutButton({super.key, required this.metamaskRepository});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: OutlinedButton(
        onPressed: () async {
          metamaskRepository.logout();

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
