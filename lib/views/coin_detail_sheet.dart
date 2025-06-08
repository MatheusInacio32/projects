import 'package:flutter/material.dart';
import '../data/models/cryptocurrency.dart';

class CoinDetailSheet extends StatelessWidget {
  final Cryptocurrency coin;
  const CoinDetailSheet({required this.coin});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      height: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${coin.name} (${coin.symbol})',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Data adicionada: ${coin.dateAdded}'),
          SizedBox(height: 8),
          Text('Preço (USD): \$${coin.priceUsd.toStringAsFixed(2)}'),
          Text('Preço (BRL): R\$${coin.priceBrl.toStringAsFixed(2)}'),
          Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Fechar'),
            ),
          ),
        ],
      ),
    );
  }
}
