import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class BinanceApi {
  final String binanceApiUrl = 'https://api.binance.com/api/v3/ticker';

  Future<double> getPrice(String symbol) async {
    final response =
        await http.get(Uri.parse('$binanceApiUrl/price?symbol=${symbol}USDT'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final price = double.parse(data['price']);
      return price;
    } else {
      throw Exception('Failed to load price');
    }
  }

  Future<double> getPriceChange(String symbol) async {
    final response =
        await http.get(Uri.parse('$binanceApiUrl/24hr?symbol=$symbol'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final priceChange = double.parse(data['priceChangePercent']);
      return priceChange;
    } else {
      throw Exception('Failed to load price change');
    }
  }

  Future<double> getMarketChanges() async {
    final response = await http.get(Uri.parse('$binanceApiUrl/24hr'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final btcPriceChange = double.parse(data.firstWhere(
          (element) => element['symbol'] == 'BTCUSDT')['priceChangePercent']);
      final ethPriceChange = double.parse(data.firstWhere(
          (element) => element['symbol'] == 'ETHUSDT')['priceChangePercent']);

      return (btcPriceChange + ethPriceChange) / 2;
    } else {
      throw Exception('Failed to load market status');
    }
  }

  Widget getCryptoIcon(String symbol) {
    final String iconUrl =
        'https://cryptoicons.org/api/white/${symbol.toLowerCase()}/100';
    return Image.network(iconUrl);
  }
}
