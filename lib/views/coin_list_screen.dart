import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/coin_list_viewmodel.dart';
import 'coin_detail_sheet.dart';

class CoinListScreen extends StatefulWidget {
  @override
  _CoinListScreenState createState() => _CoinListScreenState();
}

class _CoinListScreenState extends State<CoinListScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CoinListViewModel>(context, listen: false).fetchCoins('');
    });
  }

  Future<void> _refresh() =>
      Provider.of<CoinListViewModel>(context, listen: false)
          .fetchCoins(_controller.text);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Criptomoedas')),
      body: Consumer<CoinListViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) return Center(child: CircularProgressIndicator());
          if (vm.errorMessage.isNotEmpty)
            return Center(child: Text('Erro: ${vm.errorMessage}'));

          return RefreshIndicator(
            onRefresh: _refresh,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(8),
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      labelText: 'Símbolos (vírgula)',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: _refresh,
                      ),
                    ),
                    onSubmitted: (_) => _refresh(),
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: vm.coins.length,
                    itemBuilder: (_, i) {
                      final coin = vm.coins[i];
                      return ListTile(
                        title: Text('${coin.symbol} – ${coin.name}'),
                        subtitle: Text(
                          'USD: \$${coin.priceUsd.toStringAsFixed(2)}  BRL: R\$${coin.priceBrl.toStringAsFixed(2)}',
                        ),
                        onTap: () => showModalBottomSheet(
                          context: context,
                          builder: (_) => CoinDetailSheet(coin: coin),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
