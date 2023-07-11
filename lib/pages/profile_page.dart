import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:maskify/constants/colors.dart';
import 'package:maskify/services/metamask_service.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import '../widgets/favorite_widget.dart';
import '../widgets/profile_section_widget.dart';
import '../widgets/settings_section_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final metamaskService = Get.find<MetamaskService>();
    final panelHeight = MediaQuery.of(context).size.height / 2;

    return SlidingUpPanel(
      panel: SettingsSection(metamaskService: metamaskService),
      color: bgColor,
      minHeight: 60,
      maxHeight: panelHeight,
      backdropEnabled: true,
      borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      body: RefreshIndicator(
        onRefresh: () async {
          await metamaskService
              .updateBalanceFromBlockchain(metamaskService.userAddress.value);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ProfileSection(metamaskService: metamaskService),
                const FavoriteCoinListWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
