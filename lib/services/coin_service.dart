import 'package:crypt_io/models/coin_model.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

enum CoinSortType { all, topGainers, topLosers }

class CoinService extends GetxController {
  final _apiUrl =
      "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false";
  final _coinsList = <CoinModel>[].obs;
  final _originalCoinsList = <CoinModel>[].obs;
  final List<String> _favoriteCoinsList = [];
  final Map<int, String> _indexToIdMap = {};
  final _isLoading = true.obs;

  List<CoinModel> get coinsList => _coinsList.toList();
  List<String> get favorites => _favoriteCoinsList.toList();
  bool get isLoading => _isLoading.value;

  @override
  void onInit() {
    super.onInit();
    fetchCoins();
  }

  Future<void> fetchCoins() async {
    _isLoading(true);
    try {
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final coins = coinModelFromJson(response.body);
        _coinsList.value = coins;
        _originalCoinsList.value = List.from(coins);

        _indexToIdMap.clear();
        for (var i = 0; i < coins.length; i++) {
          _indexToIdMap[i] = coins[i].id;
        }
      }
    } finally {
      _isLoading(false);
    }
    update();
  }

  void addFavorite(String coinId) {
    _favoriteCoinsList.contains(coinId)
        ? _favoriteCoinsList.remove(coinId)
        : _favoriteCoinsList.add(coinId);
    update();
  }

  void sortCoins(CoinSortType sortType) {
    switch (sortType) {
      case CoinSortType.all:
        _coinsList.value = List.from(_originalCoinsList);
        break;
      case CoinSortType.topGainers:
        _coinsList.sort((a, b) =>
            b.priceChangePercentage24H.compareTo(a.priceChangePercentage24H));
        break;
      case CoinSortType.topLosers:
        _coinsList.sort((a, b) =>
            a.priceChangePercentage24H.compareTo(b.priceChangePercentage24H));
        break;
    }
    update();
  }

  double marketChanges24H() {
    final bitcoin = coinsList
            .firstWhereOrNull((coin) => coin.id == 'bitcoin')
            ?.priceChangePercentage24H ??
        0.0;

    final ethereum = coinsList
            .firstWhereOrNull((coin) => coin.id == 'ethereum')
            ?.priceChangePercentage24H ??
        0.0;

    return (bitcoin + ethereum) / 2;
  }

  Future<Map<String, List<double>>> fetchCoinChartData(
      String coinId, String interval) async {
    final endpoint = _getIntervalEndpoint(interval);
    final url =
        'https://api.coingecko.com/api/v3/coins/$coinId/market_chart?vs_currency=usd&days=$interval&interval=$endpoint';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      return {
        'prices': jsonResponse['prices']
            .map((price) => price[1])
            .toList()
            .cast<double>()
      };
    } else {
      throw Exception('Failed to load coin chart data');
    }
  }

  String? _getIntervalEndpoint(String interval) {
    const intervalEndpoints = {
      '24h': 'daily',
      '7d': 'daily',
      '30d': 'daily',
      '1y': 'daily'
    };
    return intervalEndpoints[interval];
  }

  void searchCoins(String name) {
    if (name.isEmpty) {
      _coinsList.value = List.from(_originalCoinsList);
    } else {
      _coinsList.value = _originalCoinsList
          .where((coin) => coin.name.toLowerCase().contains(name.toLowerCase()))
          .toList();
    }
    update();
  }
}
