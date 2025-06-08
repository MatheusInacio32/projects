import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

import 'data/datasource/coin_remote_datasource.dart';
import 'data/repository/coin_repository.dart';
import 'viewmodels/coin_list_viewmodel.dart';
import 'views/coin_list_screen.dart';

void main() {
  final dataSource = CoinRemoteDataSource(http.Client());
  final repository = CoinRepository(dataSource);

  runApp(
    ChangeNotifierProvider(
      create: (_) => CoinListViewModel(repository),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Coins MVVM',
    theme: ThemeData(primarySwatch: Colors.blue),
    home: CoinListScreen(),
  );
}
