class Cryptocurrency {
  final String symbol;
  final String name;
  final double priceUsd;
  final double priceBrl;
  final String dateAdded;

  Cryptocurrency({
    required this.symbol,
    required this.name,
    required this.priceUsd,
    required this.priceBrl,
    required this.dateAdded,
  });

  factory Cryptocurrency.fromJson(Map<String, dynamic> json) {
    final quote = json['quote'] as Map<String, dynamic>;
    final usd = quote['USD'] as Map<String, dynamic>;
    final brl = quote['BRL'] as Map<String, dynamic>?;

    return Cryptocurrency(
      symbol: json['symbol'] ?? '',
      name: json['name'] ?? '',
      priceUsd: (usd['price'] as num).toDouble(),
      priceBrl: brl != null ? (brl['price'] as num).toDouble() : 0,
      dateAdded: json['date_added'] ?? '',
    );
  }
}
