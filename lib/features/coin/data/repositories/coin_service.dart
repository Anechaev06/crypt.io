import 'package:maskify/features/coin/data/models/coin_model.dart';
import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum CoinSortType { all, topGainers, topLosers }

class CoinService extends GetxController {
  static const _apiUrl =
      "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false";
  static const _favoritesKey = 'favorites';

  final _coinsList = <CoinModel>[].obs;
  final _originalCoinsList = <CoinModel>[].obs;
  List<String> _favoriteCoinsList = [];
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
    _setLoading(true);
    try {
      final coins = await _fetchCoinsFromAPI();
      _setCoins(coins);
      _loadFavorites();
    } finally {
      _setLoading(false);
    }
    update();
  }

  Future<List<CoinModel>> _fetchCoinsFromAPI() async {
    final response = await http.get(Uri.parse(_apiUrl));
    if (response.statusCode == 200) {
      return coinModelFromJson(response.body);
    } else {
      throw Exception('Failed to fetch coins');
    }
  }

  void _setCoins(List<CoinModel> coins) {
    _coinsList.value = coins;
    _originalCoinsList.value = List.from(coins);

    _indexToIdMap.clear();
    for (var i = 0; i < coins.length; i++) {
      _indexToIdMap[i] = coins[i].id;
    }
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    _favoriteCoinsList = prefs.getStringList(_favoritesKey) ?? [];
  }

  void _setLoading(bool value) {
    _isLoading.value = value;
  }

  Future<void> addFavorite(String coinId) async {
    _toggleFavorite(coinId);
    await _persistFavorites();
    update();
  }

  void _toggleFavorite(String coinId) {
    if (_favoriteCoinsList.contains(coinId)) {
      _favoriteCoinsList.remove(coinId);
    } else {
      _favoriteCoinsList.add(coinId);
    }
  }

  Future<void> _persistFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_favoritesKey, _favoriteCoinsList);
  }

  void sortCoins(CoinSortType sortType) {
    switch (sortType) {
      case CoinSortType.all:
        _resetCoinsList();
        break;
      case CoinSortType.topGainers:
        _sortCoinsListDescending();
        break;
      case CoinSortType.topLosers:
        _sortCoinsListAscending();
        break;
    }
    update();
  }

  void _resetCoinsList() {
    _coinsList.value = List.from(_originalCoinsList);
  }

  void _sortCoinsListDescending() {
    _coinsList.sort((a, b) =>
        b.priceChangePercentage24H.compareTo(a.priceChangePercentage24H));
  }

  void _sortCoinsListAscending() {
    _coinsList.sort((a, b) =>
        a.priceChangePercentage24H.compareTo(b.priceChangePercentage24H));
  }

  double marketChanges24H() {
    final bitcoinChange = _getPriceChangePercentage('bitcoin');
    final ethereumChange = _getPriceChangePercentage('ethereum');

    return (bitcoinChange + ethereumChange) / 2;
  }

  double _getPriceChangePercentage(String coinId) {
    return _originalCoinsList
            .firstWhereOrNull((coin) => coin.id == coinId)
            ?.priceChangePercentage24H ??
        0.0;
  }

  Future<Map<String, List<double>>> fetchCoinChartData(
      String coinId, String interval) async {
    final endpoint = _getIntervalEndpoint(interval);
    final url =
        'https://api.coingecko.com/api/v3/coins/$coinId/market_chart?vs_currency=usd&days=$interval&interval=$endpoint';
    return _fetchChartData(url);
  }

  Future<Map<String, List<double>>> _fetchChartData(String url) async {
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
      _resetCoinsList();
    } else {
      _filterCoinsByName(name);
    }
    update();
  }

  void _filterCoinsByName(String name) {
    _coinsList.value = _originalCoinsList
        .where((coin) => coin.name.toLowerCase().contains(name.toLowerCase()))
        .toList();
  }
}
