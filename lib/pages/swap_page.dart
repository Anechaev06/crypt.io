import 'package:flutter/material.dart';

class SwapPage extends StatefulWidget {
  const SwapPage({super.key});

  @override
  State<SwapPage> createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> {
  static const tokens = ['ETH', 'BTC', "USDT"];
  String? dropdownValue1;
  String? dropdownValue2;
  String amount1 = '';
  String amount2 = '';

  void swapTokens() {
    setState(() {
      final tempToken = dropdownValue1;
      dropdownValue1 = dropdownValue2;
      dropdownValue2 = tempToken;

      final tempAmount = amount1;
      amount1 = amount2;
      amount2 = tempAmount;
    });
  }

  DropdownButton<String> buildDropdown(
      String? value, ValueChanged<String?> onChanged) {
    return DropdownButton(
      value: value,
      hint: const Text('Select token'),
      onChanged: onChanged,
      items: tokens
          .map((value) => DropdownMenuItem(value: value, child: Text(value)))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          buildTokenField(
              dropdownValue1, (val) => setState(() => amount1 = val),
              (newValue) {
            if (newValue != null) setState(() => dropdownValue1 = newValue);
          }),
          OutlinedButton(
            onPressed: swapTokens,
            child: const Icon(Icons.swap_vert_rounded),
          ),
          buildTokenField(
              dropdownValue2, (val) => setState(() => amount2 = val),
              (newValue) {
            if (newValue != null) setState(() => dropdownValue2 = newValue);
          }),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Submit the swap request
            },
            child: const Text('Swap tokens'),
          ),
        ],
      ),
    );
  }

  Container buildTokenField(
    String? dropdownValue,
    ValueChanged<String> onAmountChanged,
    ValueChanged<String?> onDropdownChanged,
  ) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(5.0),
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
                  labelText: '0',
                ),
              ),
            ),
            buildDropdown(dropdownValue, onDropdownChanged),
          ],
        ),
      ),
    );
  }
}
