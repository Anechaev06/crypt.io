import 'dart:async';
import 'package:crypt_io/models/coin_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CoinController extends GetxController {
  final _apiUrl =
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false';

  final _coinsList = <CoinModel>[].obs;
  List<CoinModel> get coinsList => _coinsList.toList();

  final _favoriteCoinsList = <int>[].obs;
  List<int> get favorites => _favoriteCoinsList.toList();

  final _isLoading = true.obs;
  bool get isLoading => _isLoading.value;
  // Timer? _timer;

  List<CoinModel> searchResults = [];

  @override
  void onInit() {
    super.onInit();
    fetchCoins();
    // _timer = Timer.periodic(const Duration(seconds: 30), (_) => fetchCoins());
  }

  @override
  void onClose() {
    // _timer?.cancel();
    super.onClose();
  }

  Future<void> fetchCoins() async {
    try {
      _isLoading(true);
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final coins = coinModelFromJson(response.body);
        _coinsList.value = coins;
      } else {
        throw Exception(
            'Failed to load data with status code: ${response.statusCode}');
      }
    } finally {
      _isLoading(false);
    }
    update();
  }

  void addFavorite(int index) {
    if (_favoriteCoinsList.contains(index)) {
      _favoriteCoinsList.remove(index);
    } else {
      _favoriteCoinsList.add(index);
    }
    update();
  }

  void searchCoin(String searchText) {
    if (searchText.isNotEmpty) {
      searchResults = _coinsList
          .where((coin) =>
              coin.name.toLowerCase().contains(searchText.toLowerCase()))
          .toList();
    } else {
      searchResults =
          _coinsList.toList(); // Copies all coins if the search text is empty
    }
    update();
  }
}
