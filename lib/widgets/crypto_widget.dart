import 'dart:async';
import 'package:crypt_io/pages/coin_page.dart';
import 'package:flutter/material.dart';
import '../api/binanace_api.dart';

class CryptoWidget extends StatefulWidget {
  final String symbol;

  const CryptoWidget({
    required this.symbol,
    Key? key,
  }) : super(key: key);

  @override
  State<CryptoWidget> createState() => _CryptoWidgetState();
}

class _CryptoWidgetState extends State<CryptoWidget> {
  late double price;
  late double priceChange;
  late Timer _timer;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _timer =
        Timer.periodic(const Duration(seconds: 3), (timer) => _updatePrices());
    _updatePrices();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _updatePrices() async {
    try {
      final data = await Future.wait([
        BinanceApi().getPrice(widget.symbol.toUpperCase()),
        BinanceApi().getPriceChange("${widget.symbol.toUpperCase()}USDT"),
      ]);

      if (mounted) {
        setState(() {
          price = data[0];
          priceChange = data[1];
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const CircularProgressIndicator();
    }

    if (_error != null) {
      return ListTile(
        title: Text(widget.symbol.toUpperCase()),
        subtitle: Text('Error: $_error'),
      );
    }

    final cryptoIcon = BinanceApi().getCryptoIcon(widget.symbol);
    final priceChangeColor = priceChange >= 0 ? Colors.green : Colors.red;

    return ElevatedButton(
      onPressed: () => {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(builder: (context) => const CoinPage()),
        // )
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: const EdgeInsets.only(top: 15, bottom: 15),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: 40,
                child: cryptoIcon,
              ),
              const SizedBox(width: 10),
              Text(
                widget.symbol,
                style: Theme.of(context).textTheme.labelMedium,
              ),
              const SizedBox(width: 70),
              Text(
                '24h: ${priceChange.toStringAsFixed(2)}%',
                style: TextStyle(color: priceChangeColor),
              ),
            ],
          ),
          Text(
            '\$${price.toStringAsFixed(2)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
