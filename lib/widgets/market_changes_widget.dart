import 'dart:async';

import 'package:crypt_io/api/binanace_api.dart';
import 'package:flutter/material.dart';

class MarketChanges extends StatefulWidget {
  const MarketChanges({Key? key}) : super(key: key);

  @override
  State<MarketChanges> createState() => _MarketChangesState();
}

class _MarketChangesState extends State<MarketChanges> {
  double _marketStatus = 0.0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) => _getMarketStatus(),
    );
  }

  Future<void> _getMarketStatus() async {
    final marketStatus = await BinanceApi().getMarketChanges();
    setState(() => _marketStatus = marketStatus);
  }

  @override
  Widget build(BuildContext context) {
    final marketStatusText = _marketStatus > 0
        ? 'Market is up'
        : _marketStatus < 0
            ? 'Market is down'
            : 'Market is stable';

    final marketStatusColor = _marketStatus >= 0 ? Colors.green : Colors.red;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          marketStatusText,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Row(
          children: [
            Icon(
              _marketStatus.isNegative
                  ? Icons.trending_down_rounded
                  : Icons.moving_rounded,
              color: _marketStatus.isNegative ? Colors.red : Colors.green,
            ),
            const SizedBox(width: 5),
            Text(
              '${_marketStatus.toStringAsFixed(2)}%',
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: marketStatusColor),
            ),
          ],
        ),
      ],
    );
  }
}
