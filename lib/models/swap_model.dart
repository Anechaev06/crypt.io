import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../services/swap_service.dart';

class SwapModel extends ChangeNotifier {
  static const List<String> tokenOptions = ['ETH', 'USDT'];
  String selectedToken1 = tokenOptions[0];
  String selectedToken2 = tokenOptions[1];
  String token1Amount = '';
  String token2Amount = '';

  Future<void> dropdownSwap() async {
    final tempToken = selectedToken1;
    selectedToken1 = selectedToken2;
    selectedToken2 = tempToken;

    final tempAmount = token1Amount;
    token1Amount = token2Amount;
    token2Amount = tempAmount;

    notifyListeners();
  }

  Future<void> swapTokens(String userPrivateKey) async {
    String tokenInAddress = selectedToken1;
    String tokenOutAddress = selectedToken2;
    BigInt amountIn = BigInt.parse(token1Amount);
    BigInt minAmountOut = BigInt.parse(token2Amount);

    await Get.find<SwapService>().swapTokens(
      userPrivateKey,
      tokenInAddress,
      tokenOutAddress,
      amountIn,
      minAmountOut,
    );
  }
}
