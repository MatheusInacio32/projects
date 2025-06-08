import '../datasource/coin_remote_datasource.dart';
import '../models/cryptocurrency.dart';

class CoinRepository {
  final CoinRemoteDataSource dataSource;
  CoinRepository(this.dataSource);

  Future<List<Cryptocurrency>> getCryptocurrencies(List<String> symbols) {
    return dataSource.fetchQuotes(symbols);
  }
}
