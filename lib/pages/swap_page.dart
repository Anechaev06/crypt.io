import 'package:crypt_io/services/metamask_service.dart';
import 'package:crypt_io/services/swap_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SwapPage extends StatefulWidget {
  const SwapPage({super.key});

  @override
  State<SwapPage> createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> {
  static const List<String> tokenOptions = ['ETH', 'USDT'];
  String selectedToken1 = tokenOptions[0];
  String selectedToken2 = tokenOptions[1];
  String token1Amount = '';
  String token2Amount = '';

  final SwapService swapServiceInstance = Get.find<SwapService>();

  Future<void> dropdownSwap() async {
    try {
      setState(() {
        final tempToken = selectedToken1;
        selectedToken1 = selectedToken2;
        selectedToken2 = tempToken;

        final tempAmount = token1Amount;
        token1Amount = token2Amount;
        token2Amount = tempAmount;
      });

      String? userPrivateKey = MetamaskService().privateKey;
      String tokenInAddress = selectedToken1;
      String tokenOutAddress = selectedToken2;
      BigInt amountIn = BigInt.parse(token1Amount);
      BigInt minAmountOut = BigInt.parse(token2Amount);

      await swapServiceInstance.swapTokens(userPrivateKey!, tokenInAddress,
          tokenOutAddress, amountIn, minAmountOut);
    } catch (e) {
      // Handle the error
      // print(e);
    }
  }

  Container buildTokenDropdown(String selectedToken, String otherToken,
      ValueChanged<String?> onTokenSelected) {
    var availableTokens =
        tokenOptions.where((token) => token != otherToken).toList();
    return Container(
      padding: const EdgeInsets.all(8),
      height: 50,
      width: 125,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedToken,
          alignment: Alignment.center,
          hint: const Text('Select'),
          onChanged: onTokenSelected,
          items: availableTokens
              .map(
                  (token) => DropdownMenuItem(value: token, child: Text(token)))
              .toList(),
        ),
      ),
    );
  }

  Container buildTokenAmountInputField(
    String selectedToken,
    String otherSelectedToken,
    ValueChanged<String> onAmountChanged,
    ValueChanged<String?> onTokenSelected,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                onChanged: onAmountChanged,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Amount',
                ),
              ),
            ),
            buildTokenDropdown(
                selectedToken, otherSelectedToken, onTokenSelected),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final swap_service = Get.find<SwapService>();

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1 Amount Field
          buildTokenAmountInputField(selectedToken1, selectedToken2,
              (val) => setState(() => token1Amount = val), (newValue) {
            if (newValue != null) setState(() => selectedToken1 = newValue);
          }),
          // Dropdown button Swap
          OutlinedButton(
            onPressed: dropdownSwap,
            child: const Icon(Icons.swap_vert_rounded),
          ),
          // 2 Amount Field
          buildTokenAmountInputField(selectedToken2, selectedToken1,
              (val) => setState(() => token2Amount = val), (newValue) {
            if (newValue != null) setState(() => selectedToken2 = newValue);
          }),
          const SizedBox(height: 20),
          // Swap Button
          ElevatedButton(
            onPressed: () {},
            child: const Text('Swap'),
          ),
        ],
      ),
    );
  }
}
