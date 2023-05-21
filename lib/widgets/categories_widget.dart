import 'package:flutter/material.dart';
import '../constants/colors.dart';
import '../controllers/coin_controller.dart';

class CategoriesWidget extends StatefulWidget {
  final CoinController controller;

  const CategoriesWidget({super.key, required this.controller});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  CoinSortType _selectedSortType = CoinSortType.all;

  @override
  void initState() {
    super.initState();
    widget.controller.sortCoins(_selectedSortType);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text("Assets",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildButton("All coins", CoinSortType.all),
              _buildButton("Top gainers", CoinSortType.topGainers),
              _buildButton("Top losers", CoinSortType.topLosers),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildButton(String title, CoinSortType type) {
    final isSelected = _selectedSortType == type;
    return isSelected
        ? ElevatedButton(
            onPressed: () => _updateSortType(type),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: bgColor),
            ),
          )
        : OutlinedButton(
            onPressed: () => _updateSortType(type),
            style: OutlinedButton.styleFrom(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
            ),
            child: Text(title, style: Theme.of(context).textTheme.bodyMedium),
          );
  }

  void _updateSortType(CoinSortType type) {
    setState(() => _selectedSortType = type);
    widget.controller.sortCoins(type);
  }
}
