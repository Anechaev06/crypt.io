import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web3dart/web3dart.dart';

class MetamaskController extends GetxController {
  static const String _infuraUrl =
      'https://mainnet.infura.io/v3/0430f534a77347f493105efbfd376383';

  late final Web3Client _ethClient;
  late final Client _httpClient;
  var userAddress = ''.obs;
  var balance = '0'.obs;

  MetamaskController() {
    _httpClient = Client();
    _ethClient = Web3Client(_infuraUrl, _httpClient);
    loadSavedData();
  }

  Future<void> loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userAddress.value = prefs.getString('userAddress') ?? '';
    balance.value = prefs.getString('balance') ?? '0';
  }

  Future<void> saveData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('userAddress', userAddress.value);
    prefs.setString('balance', balance.value);
  }

  Future<void> getBalance(String address) async {
    userAddress.value = address;
    EthereumAddress ethereumAddress = EthereumAddress.fromHex(address);
    EtherAmount etherAmount = await _ethClient.getBalance(ethereumAddress);
    balance.value = etherAmount.getValueInUnit(EtherUnit.ether).toString();
    saveData();
  }
}
