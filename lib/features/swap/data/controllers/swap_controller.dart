import '../models/swap_model.dart';
import '../../../metamask/data/repositories/metamask_repository.dart';

class SwapController {
  final SwapModel _model;

  SwapController(this._model);

  void dropdownSwap() => _model.dropdownSwap();

  void selectToken1(String? newValue) {
    if (newValue != null) {
      _model.selectedToken1 = newValue;
    }
  }

  void selectToken2(String? newValue) {
    if (newValue != null) {
      _model.selectedToken2 = newValue;
    }
  }

  void enterAmount1(String val) => _model.token1Amount = val;

  void enterAmount2(String val) => _model.token2Amount = val;

  Future<void> swapTokens() async {
    String? userPrivateKey = MetamaskRepository().privateKey;
    if (userPrivateKey != null) {
      await _model.swapTokens(userPrivateKey);
    }
  }
}
