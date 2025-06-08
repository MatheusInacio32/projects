import 'package:flutter/material.dart';
import '../data/models/cryptocurrency.dart';
import '../data/repository/coin_repository.dart';

class CoinListViewModel extends ChangeNotifier {
  final CoinRepository repository;
  List<Cryptocurrency> _coins = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<Cryptocurrency> get coins => _coins;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  CoinListViewModel(this.repository);

  Future<void> fetchCoins(String inputSymbols) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      final symbols = inputSymbols.isEmpty
          ? [
        'BTC','ETH','SOL','BNB','BCH','MKR','AAVE','DOT','SUI','ADA','XRP','TIA',
        'NEO','NEAR','PENDLE','RENDER','LINK','TON','XAI','SEI','IMX','ETHFI',
        'UMA','SUPER','FET','USUAL','GALA','PAAL','AERO'
      ]
          : inputSymbols
          .split(',')
          .map((e) => e.trim().toUpperCase())
          .toList();

      _coins = await repository.getCryptocurrencies(symbols);
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
