import 'package:flutter/material.dart';
import 'package:maskify/app/constants/colors.dart';
import 'package:maskify/features/swap/data/models/swap_model.dart';
import 'package:maskify/features/swap/data/controllers/swap_controller.dart';
import 'package:provider/provider.dart';

class SwapPage extends StatefulWidget {
  const SwapPage({super.key});

  @override
  State<SwapPage> createState() => _SwapPageState();
}

class _SwapPageState extends State<SwapPage> {
  late SwapModel _model;
  late SwapController _controller;

  @override
  void initState() {
    super.initState();
    _model = SwapModel();
    _controller = SwapController(_model);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Swap"),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ChangeNotifierProvider.value(
        value: _model,
        child: Consumer<SwapModel>(
          builder: (context, model, child) => Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                buildTokenAmountInputField(
                  model.selectedToken1,
                  model.selectedToken2,
                  _controller.enterAmount1,
                  _controller.selectToken1,
                ),
                OutlinedButton(
                  onPressed: _controller.dropdownSwap,
                  child: const Icon(Icons.swap_vert_rounded),
                ),
                buildTokenAmountInputField(
                  model.selectedToken2,
                  model.selectedToken1,
                  _controller.enterAmount2,
                  _controller.selectToken2,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _controller.swapTokens,
                  child: const Text('Swap'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container buildTokenDropdown(
    String selectedToken,
    String otherToken,
    ValueChanged<String?> onTokenSelected,
  ) {
    var availableTokens =
        SwapModel.tokenOptions.where((token) => token != otherToken).toList();
    return Container(
      padding: const EdgeInsets.all(8),
      height: 50,
      width: 125,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: newPrimaryColor),
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
                decoration: InputDecoration(
                  border: InputBorder.none,
                  labelText: 'Amount',
                  labelStyle: TextStyle(
                    color: Colors.grey.withOpacity(0.3),
                  ),
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
}
