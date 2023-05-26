import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';

class MetamaskController extends GetxController {
  // URLs and client setup
  static const String _infuraUrl =
      'https://mainnet.infura.io/v3/e799541effb8472d8a0ac96631acd045';
  static const String _bscUrl = 'https://bsc-dataseed.binance.org/';
  late final Web3Client _ethClient;
  late final Web3Client _bscClient;
  late Web3Client _activeClient;

  // State variables
  final userAddress = ''.obs;
  final balance = '0'.obs;
  final hideBalance = false.obs;
  final activeNetwork = 'eth'.obs;

  // Initialization and cleanup
  @override
  void onInit() {
    super.onInit();
    _ethClient = Web3Client(_infuraUrl, http.Client());
    _bscClient = Web3Client(_bscUrl, http.Client());
    _activeClient = _ethClient; // Default to Ethereum network
    loadSavedData();
  }

  @override
  void onClose() {
    _ethClient.dispose();
    _bscClient.dispose();
    super.onClose();
  }

  // Business logic
  void switchNetwork(String network) {
    _activeClient = network == 'eth' ? _ethClient : _bscClient;
    activeNetwork.value = network;
    getBalance(userAddress.value);
  }

  void updateBalance(String newBalance) {
    balance.value = newBalance;
    saveData();
  }

  void toggleHideBalance(bool value) {
    hideBalance.value = value;
    saveData();
  }

  void updateUserAddress(String newAddress) {
    userAddress.value = newAddress;
    saveData();
  }

  Future<void> loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    userAddress.value = prefs.getString('userAddress') ?? '';
    balance.value = prefs.getString('balance') ?? '0';
    activeNetwork.value = prefs.getString('activeNetwork') ?? 'eth';
    hideBalance.value = prefs.getBool('hideBalance') ?? false;
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userAddress', userAddress.value);
    prefs.setString('balance', balance.value);
    prefs.setString('activeNetwork', activeNetwork.value);
    prefs.setBool('hideBalance', hideBalance.value);
  }

  Future<void> getBalance(String address) async {
    try {
      userAddress.value = address;
      EthereumAddress ethereumAddress = EthereumAddress.fromHex(address);
      EtherAmount etherAmount = await _activeClient.getBalance(ethereumAddress);
      balance.value = etherAmount.getValueInUnit(EtherUnit.ether).toString();

      String conversionURL = activeNetwork.value == 'eth'
          ? 'https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd'
          : 'https://api.coingecko.com/api/v3/simple/price?ids=binancecoin&vs_currencies=usd';

      double conversionRate = await getConversionRate(conversionURL);
      double usdBalance = double.parse(balance.value) * conversionRate;
      balance.value = usdBalance.toStringAsFixed(2);

      await saveData();
    } catch (e) {
      print('Error in getBalance: $e');
    }
  }

  Future<double> getConversionRate(String url) async {
    try {
      var response = await http.get(Uri.parse(url));
      var jsonResponse = jsonDecode(response.body);

      if (activeNetwork.value == 'eth') {
        return jsonResponse['ethereum']['usd'];
      } else {
        return jsonResponse['binancecoin']['usd'];
      }
    } catch (e) {
      print('Error in getConversionRate: $e');
      return 0.0;
    }
  }

  void logout() {
    updateUserAddress('');
    updateBalance('0');
    switchNetwork('eth');
    toggleHideBalance(false);
  }
}
