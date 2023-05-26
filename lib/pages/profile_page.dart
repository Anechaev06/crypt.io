import 'package:crypt_io/pages/login_page.dart';
import 'package:crypt_io/widgets/favorite_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/metamask_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final metamaskController = Get.find<MetamaskController>();

    return Padding(
      padding: const EdgeInsets.all(25),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildProfileSection(metamaskController),
            const FavoriteCoinWidget(),
            const SizedBox(height: 20),
            _buildSettingsSection(context, metamaskController),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileSection(MetamaskController metamaskController) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(height: 100, child: Image.asset("assets/images/metamask.png")),
        Obx(() {
          return Text(
            metamaskController.hideBalance.value
                ? '***'
                : '\$${metamaskController.balance.value}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          );
        }),
        _buildElevatedButton(metamaskController),
      ],
    );
  }

  Widget _buildElevatedButton(MetamaskController metamaskController) {
    return ElevatedButton(
      onPressed: () {
        Clipboard.setData(
            ClipboardData(text: metamaskController.userAddress.value));
      },
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18.0),
          ),
        ),
      ),
      child: Obx(() {
        final userAddress = metamaskController.userAddress.value;
        return Text(
          userAddress.isEmpty
              ? ""
              : "${userAddress.substring(0, 6)}...${userAddress.substring(userAddress.length - 4)}",
        );
      }),
    );
  }

  Widget _buildSettingsSection(
      BuildContext context, MetamaskController metamaskController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          "Settings",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        _buildHideBalance(context, metamaskController),
        const Divider(height: 5, thickness: 0.25, color: Colors.grey),
        _buildNetwork(context, metamaskController),
        const Divider(height: 5, thickness: 0.25, color: Colors.grey),
        // _buildPushNotifications(context, metamaskController),
        _buildLogoutButton(context, metamaskController)
      ],
    );
  }

  Widget _buildHideBalance(
      BuildContext context, MetamaskController metamaskController) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Hide Balance", style: TextStyle(fontSize: 20)),
            Switch(
              value: metamaskController.hideBalance.value,
              onChanged: (value) {
                metamaskController.hideBalance.value = value;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetwork(
      BuildContext context, MetamaskController metamaskController) {
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
              value: metamaskController.activeNetwork.value,
              items: <String>['eth', 'bsc'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value.toUpperCase()),
                );
              }).toList(),
              onChanged: (newValue) {
                if (newValue != null) {
                  metamaskController.switchNetwork(newValue);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPushNotifications(
      BuildContext context, MetamaskController metamaskController) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Push Notifications", style: TextStyle(fontSize: 20)),
            Switch(
              value: metamaskController.hideBalance.value,
              onChanged: (value) {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoutButton(
      BuildContext context, MetamaskController metamaskController) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: OutlinedButton(
        onPressed: () async {
          metamaskController.logout();

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
