import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';

class MetamaskService extends GetxController {
  static const _infuraUrl =
      "https://mainnet.infura.io/v3/e799541effb8472d8a0ac96631acd045";
  static const _bscUrl = "https://bsc-dataseed.binance.org/";

  final userAddress = ''.obs;
  final balance = '0'.obs;
  final hideBalance = false.obs;
  final activeNetwork = 'eth'.obs;
  final isNotificationEnabled = true.obs;
  late String? _privateKey;

  late final Web3Client _ethClient;
  late final Web3Client _bscClient;
  late Web3Client _activeClient;

  Web3Client get activeClient => _activeClient;
  String? get privateKey => _privateKey;

  // Initializes the service.
  @override
  void onInit() {
    super.onInit();
    _ethClient = Web3Client(_infuraUrl, http.Client());
    _bscClient = Web3Client(_bscUrl, http.Client());
    _activeClient = _ethClient; // Default to Ethereum network
    _loadSavedData();
  }

  // Cleans up the service.
  @override
  void onClose() {
    _ethClient.dispose();
    _bscClient.dispose();
    super.onClose();
  }

  // Logs in a user with a private key.
  Future<void> loginWithPrivateKey(String privateKeyInput) async {
    try {
      _privateKey = privateKeyInput;
      final credentials = EthPrivateKey.fromHex(privateKeyInput);
      final address = credentials.address;
      updateUserAddress(address.hex);
    } catch (e) {
      throw Exception('Error while logging in with private key: $e');
    }
  }

  // Fetches balance from the blockchain and updates it.
  Future<void> _updateBalanceFromBlockchain(String address) async {
    try {
      EthereumAddress ethereumAddress = EthereumAddress.fromHex(address);
      EtherAmount etherAmount = await _activeClient.getBalance(ethereumAddress);
      String rawBalance =
          etherAmount.getValueInUnit(EtherUnit.ether).toString();

      double usdBalance = await _convertToUSD(rawBalance);
      balance.value = usdBalance.toStringAsFixed(2);

      _saveData();
    } catch (e) {
      throw Exception('Error while fetching balance: $e');
    }
  }

  // Switches between Ethereum and BSC networks.
  void switchNetwork(String network) {
    _activeClient = network == 'eth' ? _ethClient : _bscClient;
    activeNetwork.value = network;
    _updateBalanceFromBlockchain(userAddress.value);
  }

  // Toggles the visibility of balance.
  void toggleHideBalance(bool value) {
    hideBalance.value = value;
    _saveData();
  }

  // Updates user's address and fetches the balance from the blockchain.
  void updateUserAddress(String newAddress) {
    userAddress.value = newAddress;
    _saveData();
    _updateBalanceFromBlockchain(userAddress.value);
  }

  // Saves user data to local storage.
  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('userAddress', userAddress.value);
    prefs.setString('balance', balance.value);
    prefs.setString('activeNetwork', activeNetwork.value);
    prefs.setBool('hideBalance', hideBalance.value);
  }

  // Loads user data from local storage.
  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    userAddress.value = prefs.getString('userAddress')!;
    balance.value = prefs.getString('balance')!;
    activeNetwork.value = prefs.getString('activeNetwork')!;
    hideBalance.value = prefs.getBool('hideBalance')!;
  }

  // Fetches the conversion rate from the API and converts the balance to USD.
  Future<double> _convertToUSD(String balance) async {
    String conversionURL = activeNetwork.value == 'eth'
        ? 'https://api.coingecko.com/api/v3/simple/price?ids=ethereum&vs_currencies=usd'
        : 'https://api.coingecko.com/api/v3/simple/price?ids=binancecoin&vs_currencies=usd';

    double conversionRate = await _getConversionRate(conversionURL);
    return double.parse(balance) * conversionRate;
  }

  // Fetches the conversion rate from the API.
  Future<double> _getConversionRate(String url) async {
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data.values.first['usd'];
      } else {
        throw Exception('Failed to load conversion rate');
      }
    } catch (e) {
      throw Exception('Error while fetching conversion rate: $e');
    }
  }

  // Clears the privateKey when a user logs out
  void logout() {
    updateUserAddress('');
    balance.value = '0';
    switchNetwork('eth');
    toggleHideBalance(false);
    _privateKey = null;
  }
}
