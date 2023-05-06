import 'dart:async';
import 'package:crypt_io/models/coin_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CoinController extends GetxController {
  final _isLoading = true.obs;
  final _coinsList = <CoinModel>[].obs;
  final _apiUrl =
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=false&locale=en';

  Timer? _timer;

  bool get isLoading => _isLoading.value;
  List<CoinModel> get coinsList => _coinsList.toList();

  @override
  void onInit() {
    super.onInit();
    fetchCrypto();
    _timer = Timer.periodic(const Duration(seconds: 30), (_) => fetchCrypto());
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> fetchCrypto() async {
    try {
      _isLoading(true);
      final response = await http.get(Uri.parse(_apiUrl));
      if (response.statusCode == 200) {
        final coins = coinModelFromJson(response.body);
        _coinsList.value = coins;
      } else {
        throw Exception('Failed to load data');
      }
    } finally {
      _isLoading(false);
    }
  }
}
