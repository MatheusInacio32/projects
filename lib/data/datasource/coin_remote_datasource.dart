import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cryptocurrency.dart';

class CoinRemoteDataSource {
  static const _baseUrl = 'pro-api.coinmarketcap.com';
  static const _apiKey = 'f8169aa5-cce6-441c-8808-f78246e3c28e';

  final http.Client client;
  CoinRemoteDataSource(this.client);

  Future<List<Cryptocurrency>> fetchQuotes(List<String> symbols) async {
    final usdUri = Uri.https(
      _baseUrl,
      '/v1/cryptocurrency/quotes/latest',
      {
        'symbol': symbols.join(','),
        'convert': 'USD',
      },
    );
    print('Chamando USD: $usdUri');
    final usdResp = await client.get(
      usdUri,
      headers: {
        'Accepts': 'application/json',
        'X-CMC_PRO_API_KEY': _apiKey,
      },
    );
    if (usdResp.statusCode != 200) {
      print('USD erro: ${usdResp.body}');
      throw Exception('Falha USD: ${usdResp.statusCode}\n${usdResp.body}');
    }
    final usdData = (json.decode(usdResp.body) as Map<String, dynamic>)['data']
    as Map<String, dynamic>;

    final brlUri = Uri.https(
      _baseUrl,
      '/v1/cryptocurrency/quotes/latest',
      {
        'symbol': symbols.join(','),
        'convert': 'BRL',
      },
    );
    print('Chamando BRL: $brlUri');
    final brlResp = await client.get(
      brlUri,
      headers: {
        'Accepts': 'application/json',
        'X-CMC_PRO_API_KEY': _apiKey,
      },
    );
    if (brlResp.statusCode != 200) {
      print('BRL erro: ${brlResp.body}');
      throw Exception('Falha BRL: ${brlResp.statusCode}\n${brlResp.body}');
    }
    final brlData = (json.decode(brlResp.body) as Map<String, dynamic>)['data']
    as Map<String, dynamic>;

    final List<Cryptocurrency> result = [];
    for (final symbol in symbols) {
      final uEntry = usdData[symbol];
      if (uEntry == null) continue;

      final uMap = uEntry as Map<String, dynamic>;
      final uQuote = (uMap['quote'] as Map<String, dynamic>?)?['USD']
      as Map<String, dynamic>?;
      if (uQuote == null || uQuote['price'] == null) continue;

      final priceUsd = (uQuote['price'] as num).toDouble();

      double priceBrl = 0.0;
      final bEntry = brlData[symbol] as Map<String, dynamic>?;
      if (bEntry != null) {
        final bQuote = (bEntry['quote'] as Map<String, dynamic>?)?['BRL']
        as Map<String, dynamic>?;
        if (bQuote != null && bQuote['price'] != null) {
          priceBrl = (bQuote['price'] as num).toDouble();
        }
      }

      result.add(Cryptocurrency(
        symbol: uMap['symbol'] ?? symbol,
        name: uMap['name'] ?? '',
        priceUsd: priceUsd,
        priceBrl: priceBrl,
        dateAdded: uMap['date_added'] ?? '',
      ));
    }

    if (result.isEmpty) {
      throw Exception(
        'Nenhuma criptomoeda válida encontrada para: ${symbols.join(', ')}',
      );
    }

    return result;
  }
}
