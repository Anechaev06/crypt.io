import 'package:get/get.dart';
import 'package:web3dart/web3dart.dart';
import 'metamask_service.dart';

class SwapService extends GetxController {
  final MetamaskService _metamaskService = Get.find<MetamaskService>();
  final String _uniswapRouterAddress =
      "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";
  final String _pancakeswapRouterAddress =
      "0x10ED43C718714eb63d5aA57B78B54704E256024E";

  Future<void> approveTokenContract(
    String privateKey,
    String tokenContractAddress,
    BigInt amount,
  ) async {
    try {
      final credentials = EthPrivateKey.fromHex(privateKey);
      final tokenContract = DeployedContract(
        ContractAbi.fromJson(
          '[{"constant":false,"inputs":[{"name":"spender","type":"address"},{"name":"value","type":"uint256"}],"name":"approve","outputs":[{"name":"","type":"bool"}],"payable":false,"stateMutability":"nonpayable","type":"function"}]',
          'Token',
        ),
        EthereumAddress.fromHex(tokenContractAddress),
      );

      final approveFunction = tokenContract.function('approve');
      final routerAddress = _metamaskService.activeNetwork.value == 'eth'
          ? EthereumAddress.fromHex(_uniswapRouterAddress)
          : EthereumAddress.fromHex(_pancakeswapRouterAddress);

      var transaction = Transaction.callContract(
        contract: tokenContract,
        function: approveFunction,
        parameters: [routerAddress, amount],
      );

      var response = await _metamaskService.activeClient.sendTransaction(
        credentials,
        transaction,
        fetchChainIdFromNetworkId: true,
      );

      var receipt =
          await _metamaskService.activeClient.getTransactionReceipt(response);

      throw ('Token approved: ${receipt!.blockHash}');
    } catch (e) {
      throw Exception('Error while approving token contract: $e');
    }
  }

  Future<void> swapTokens(
    String privateKey,
    String tokenInAddress,
    String tokenOutAddress,
    BigInt amountIn,
    BigInt minAmountOut,
  ) async {
    try {
      final credentials = EthPrivateKey.fromHex(privateKey);
      final routerContract = DeployedContract(
        ContractAbi.fromJson(
          '[{"constant":false,"inputs":[{"name":"amountIn","type":"uint256"},{"name":"amountOutMin","type":"uint256"},{"name":"path","type":"address[]"},{"name":"to","type":"address"},{"name":"deadline","type":"uint256"}],"name":"swapExactTokensForTokens","outputs":[{"name":"amounts","type":"uint256[]"}],"payable":false,"stateMutability":"nonpayable","type":"function"}]',
          'Router',
        ),
        _metamaskService.activeNetwork.value == 'eth'
            ? EthereumAddress.fromHex(_uniswapRouterAddress)
            : EthereumAddress.fromHex(_pancakeswapRouterAddress),
      );

      final swapFunction = routerContract.function('swapExactTokensForTokens');
      final tokenIn = EthereumAddress.fromHex(tokenInAddress);
      final tokenOut = EthereumAddress.fromHex(tokenOutAddress);
      final deadline = BigInt.from(
          (DateTime.now().millisecondsSinceEpoch / 1000).round() +
              60 * 20); // 20 minutes from now

      var transaction = Transaction.callContract(
        contract: routerContract,
        function: swapFunction,
        parameters: [
          amountIn,
          minAmountOut,
          [tokenIn, tokenOut],
          EthereumAddress.fromHex(_metamaskService.userAddress.value),
          deadline
        ],
      );

      var response = await _metamaskService.activeClient.sendTransaction(
        credentials,
        transaction,
        fetchChainIdFromNetworkId: true,
      );

      var receipt =
          await _metamaskService.activeClient.getTransactionReceipt(response);

      throw ('Token swap initiated: ${receipt!.blockHash}');
    } catch (e) {
      throw Exception('Error while swapping tokens: $e');
    }
  }
}
